# This concern is meant to handle models that are temporarily preserved after
# a user "deletes" them. 
#
# To implement this concern, the model needs the following attributes
#   - boolean:  deleted
#   - datetime: deleted_at

module Recoverable
  extend ActiveSupport::Concern
  

  included do
    scope :deleted,         ->      {where(deleted: true)}
    scope :not_deleted,     ->      {where(deleted: false)}
    scope :deleted_before,  ->  (i) {where('deleted_at < ?', i)}
    before_create :init_deleted
  end

  class_methods do
    # Sets the time to wait before deletion
    def delete_after(time) # EXAMPLE: delete_after 30.days
      @TIME_TO_WAIT_BEFORE_DELETION = time
    end

    def TIME_TO_WAIT_BEFORE_DELETION
      @TIME_TO_WAIT_BEFORE_DELETION ||= 30.days # default to 30.days
    end

    def deletion_threshold
      DateTime.current - self.TIME_TO_WAIT_BEFORE_DELETION
    end
  end

  def deleted?
    deleted
  end

  def mark_as_deleted
    self.deleted = true
    self.deleted_at = DateTime.now
    if self.save
      self
    else
      false
    end
  end

  def recover
    self.deleted = false
    if self.save
      self
    else
      false
    end
  end

  def will_be_permanently_deleted_at
    if deleted?
      deletion_date = deleted_at + self.class.TIME_TO_WAIT_BEFORE_DELETION
    end
  end

  private

  def init_deleted
    self.deleted = false if deleted.nil?
  end
end