class ReleasesController < ApplicationController
  # GET /releases
  # GET /releases.xml
  def index
    @releases = Release.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.xml
  def show
    @release = Release.find(params[:id])
    @goes_in = @release.commits.find(:all, :conditions => "status = 'goes_in'" )
    @blocked = @release.commits.find(:all, :conditions => "status = 'blocked'" )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @release }
    end
  end

  # GET /releases/new
  # GET /releases/new.xml
  def new
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
  end
  
  # GET /releases/stats/1
  def stats
    @release = Release.find(params[:id], :include => :commits)
    @stats = @release.stats
        
    respond_to do |format|
      format.html
      format.js { render :json => @stats, :status => :ok }
    end
  end
  
  # GET /releases/svn_commands/1
  def svn_commands
    @release = Release.find(params[:id], :include => :commits);
    @blocked = @release.commits.blocked
    @approved = @release.commits.approved
  end

  # POST /releases
  # POST /releases.xml
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        flash[:notice] = 'Release was successfully created.'
        format.html { redirect_to(new_release_commit_url(@release)) }
        format.xml  { render :xml => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.xml
  def update
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        flash[:notice] = 'Release was successfully updated.'
        format.html { redirect_to(@release) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.xml
  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to(releases_url) }
      format.xml  { head :ok }
    end
  end
end
