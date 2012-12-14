require 'active_model'
require 'yaml'

module SitemplateWysihat
  class Configuration
    include ActiveModel::Validations

    def initialize(&blk)
      blk.call self if block_given?
    end
  end
end

