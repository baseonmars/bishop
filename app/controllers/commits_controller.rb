class CommitsController < ApplicationController
  require 'redcloth'
  
  before_filter :get_release, :except => 'index'
    
  # GET /commits
  # GET /commits.xml  
  def index
    @release = Release.find(params[:release_id], :include => :commits)
    @commits = @release.commits.find(:all)
    @stats = @release.stats
    @commits_going_in = @release.commits.find(:all, :conditions => "status == 'goes_in'")
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commits }
    end
  end

  # GET /commits/1
  # GET /commits/1.xml
  def show
    @commit = Commit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commit }
    end
  end

  # GET /commits/new
  # GET /commits/new.xml
  def new
    @commit = Commit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @commit }
    end
  end

  # GET /commits/1/edit
  def edit
    @commit = Commit.find(params[:id])
  end

  # POST /commits
  # POST /commits.xml
  def create
    @commit = @release.commits.new(params[:commit])

    respond_to do |format|
      if @commit.save
        flash[:notice] = 'Commit was successfully created.'
        format.html { redirect_to( release_commit_url(@release, @commit)) }
        format.xml  { render :xml => @commit, :status => :created, :location => @commit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @commit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /commits/1
  # PUT /commits/1.xml
  def update
    @commit = Commit.find(params[:id])
    
    respond_to do |format|
      if @commit.update_attributes(params[:commit])
        expire_fragment(:controller => "commit", :commit => @commit.id, :type => 'commit_controls')
        flash[:notice] = 'Commit was successfully updated.'
        format.js { 
          render :update do |page|
            if params[:no_redirect] == "true"
              page.visual_effect :highlight, "commit#{@commit.revision}"
            else
              stats = @commit.release.stats
              pos = ( @commit.status == "unset" ) ? pos = :bottom : pos = :top
              page.visual_effect :fade, "commit#{@commit.revision}", :durations => 0.4
              page.delay(0.4) do
                page.replace "commit#{@commit.revision}", :partial => "commit", :locals => {:commit => @commit }
                page.replace "release-stats", :partial => 'releases/stat_graphy', :locals => {:stats => stats }
              end
              
            end
          end
        }
        format.html { redirect_to("#{release_commits_url(@release)}\#commit#{@commit.revision}") }
        format.xml  { head :ok }
      else
        format.js   { head :unprocessable_entity }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /commits/1
  # DELETE /commits/1.xml
  def destroy
    @commit = @release.commits.find(params[:id])
    @commit.destroy

    respond_to do |format|
      format.html { redirect_to(release_commits_url(@release)) }
      format.xml  { head :ok }
    end
  end
  
  def bulk_load
    svn_log = params[:svn_log]
    
    flash[:log] = "got log, it's this big: #{svn_log.size}!"
    
    process_bulk(svn_log)

    respond_to do |format|
      format.html { redirect_to(release_commits_url(@release)) }
      format.xml  { head :ok }
    end
  end
  
  def update_commits_and_stats
    
  end
  
  private
  def get_release
    @release = Release.find(params[:release_id])
  end

  def process_bulk(log)
    commits = []
    count = -1

    log.each_line do |line|
      unless line[/[-]{72}/]
        commits[count] = commits[count] ? commits[count] + line : line
      else
        count += 1
      end
    end
    
    # this regexp is stupid. one day i will explain it. basically just grabbing
    # the fields that we need to create a Commit object
    regexp = /r(\d+) \| (\w+) \| (.*?)\|.*?[\n\r]+Changed paths:[\r\n]+((?:\s+[ADMCXS]+\s.*[\n\r]+)*)[\n\r]+((?:[\s[:print:]])*)/s
    
    commits.map!{ |commit| commit.match(regexp) }
    
    # usings variable keys as a template, merge it into the array of results to produce array pairs.
    # flatten the resulting nested arrays then splat out. Hash uses each pair of args to construct a hash
    keys = [:revision, :user, :date, :files, :comments]

    commits.map! { |v| Hash[*keys.dup.zip(v[1..5]).flatten] }
    commits.map! do |c| 
      com = @release.commits.new(c) 
      extract_comments(com).save
    end
  end
  
  def extract_comments(commit)
    {:bug => /(bug \d{4}.*)$/i,
    :changes => /^changes(?:\s?(?::|-)\s?)+(.*?)$/mi,
    :testing => /^testing(?:\s?(?::|-)\s?)+(.*?)$/mi
    }.each do |k,v|
      if commit.comments =~ v then
        commit.changes_text ||= ""
        $~[1..-1].each { |comment| commit.changes_text += comment }
        if [:bug, :testing].include? k then
          commit.testing_text ||= ""
          $~[1..-1].each {|comment| commit.testing_text += comment }
        end
      end
    end
    return commit
  end
  
end