require 'simple_form'
require 'carrierwave'

module SitemplateWysihat
  class Engine < ::Rails::Engine
    config.to_prepare do
      ActiveSupport.on_load :action_controller do
        ApplicationController.helper :sitemplate_wysihat
      end
    end
  end
end
