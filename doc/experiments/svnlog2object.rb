class Commit
  attr_accessor :revision, :user, :date, :files, :comments
  def initialize(revision, user, date_string, files, comments)
    @revision = revision.to_i
    @user = user.strip
    @date = DateTime.parse(date_string)
    @files = files.split('\n')
    @comments = comments
  end
end

COMMIT_REGEXP = /r(\d{3,}) \| (.*?) \| (.*?) \| (?:.*?)\n(?:Changed paths:\n)((?:\s{3}.*?)*)\n\n((?:.|\n)*)/s

log = File.new("svnmerge.log", "r")

commits = []
count = -1;

log.each_line do |line|
  unless line[/[-]{72}/]
    commits[count] = commits[count] ? commits[count] + line : line
  else
    count += 1
  end
end

commits.map!{ |commit| commit.match(COMMIT_REGEXP)}.compact!

# usings keys as a template merge them into the array of results to produce array pairs.
# flatten the resulting nested arrays then splat out. Hash uses the pairs to construct kvp's
keys = [:revision, :user, :date, :files, :comments]
commits.map!{ |v| Hash[*keys.dup.zip(v[1..5]).flatten] }

puts "Found #{commits.size} commits"
# 
# com_obj = []
# matches.each do |match|
#   com_obj << Commit.new(*match[1..5])
# end
# 
# puts com_obj.length