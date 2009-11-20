class Commit < ActiveRecord::Base
  belongs_to :release
  
  named_scope :processed, :conditions => ['status in (?,?)', *['blocked','goes_in']]
  named_scope :unset, :conditions => ['status = ?', 'unset']
  named_scope :approved, :conditions => ['status = ?', 'goes_in']
  named_scope :blocked, :conditions => ['status = ?', 'blocked']
  
  VALID_STATUS = ["unset", "goes_in", "blocked"]
  HUMAN_STATUSES = {"unset" => "Un set", "goes_in" => "Goes in", "blocked" => "Blocked"}
  MACHINE_STATUSES = {"Un set" => "unset", "Put in" => "goes_in", "Block" => "blocked"}

  def initialize(params = nil)
    super
    self.status = "unset" unless self.status
  end

  def status=(status)
    self[:status] = paramatize_status(status)
  end

  def changes_text=(text)
    self[:changes_text] = text == "0" ? "" : text
  end

  def testing_text=(text)
    self[:testing_text] = text == "0" ? "" : text
  end

  def self.valid_statuses
    VALID_STATUS
  end

  def status_h
    HUMAN_STATUSES[self.status]
  end

  private
  def paramatize_status(status_string)
    return MACHINE_STATUSES[status_string] || status_string
  end

end