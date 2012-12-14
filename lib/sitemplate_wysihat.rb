require "sitemplate_wysihat/rails/routes"
require "sitemplate_wysihat/engine"
require "sitemplate_wysihat/configuration"

module SitemplateWysihat

  mattr_accessor :config

  def self.setup(&blk)
    @@config = SitemplateWysihat::Configuration.new(&blk)
    unless @@config.valid?
      msg = "SitemplateWysihat configuration ERROR:\n"
      config.errors.each do |field, message|
        msg += "\t#{field}: #{message}\n"
      end
      raise msg
    end
  end
end
