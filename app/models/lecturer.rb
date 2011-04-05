class Lecturer < ActiveRecord::Base
  set_table_name :lecturer
  set_primary_key :lecturerid
  has_many :lessons, :foreign_key => :lecturerid

  scope :rav, where('lecturername LIKE \'%Rav%\'').limit(1)

  def to_param
    read_attribute :lecturerid
  end

  def to_s
    lecturername
  end
end
