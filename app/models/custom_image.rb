require 'file_size_validator'

class CustomImage < ActiveRecord::Base
  mount_uploader :uploaded_file, CustomImageUploader
  validates :uploaded_file, presence: true,
                            file_size: { maximum: 10.megabytes }

  validates :width, :height, presence: true,
                             numericality: { only_integer: true,
                                             greater_than: 0 }
  after_initialize :assign_default_geometry

  attr_accessible :uploaded_file, :width, :height

  private

  def assign_default_geometry
    self.width = 300
    self.height = 300
  end
end
