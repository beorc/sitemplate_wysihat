require 'file_size_validator'

class CustomImage < ActiveRecord::Base
  mount_uploader :uploaded_file, CustomImageUploader
  validates :uploaded_file, presence: true, file_size: { maximum: 10.megabytes }
  validates :width, presence: true, numericality: { only_integer: true }
  validates :height, presence: true, numericality: { only_integer: true }
  after_initialize :assign_default_geometry

  attr_accessible :uploaded_file, :width, :height

  private

  def assign_default_geometry
    self.width = 100
    self.height = 100
  end
end
