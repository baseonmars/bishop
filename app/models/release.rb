class Release < ActiveRecord::Base
  has_many :commits
  
  def stats
    total =  self.commits.length.to_f
    processed = self.commits.processed.length.to_f
    unset = self.commits.unset.length.to_f
    
    {
      :total => total,
      :processed => processed,
      :unset => unset,
      :percent => {
        :total => 100,
        :processed => ((processed / total) * 100).round,
        :unset => ((unset / total ) * 100).round
      }
    }
  end
end
