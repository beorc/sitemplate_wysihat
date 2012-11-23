require 'simple_form'
require 'bootstrap-sass'
require 'remotipart'
require 'RMagick'
require 'carrierwave'

module SitemplateWysihat
  class Engine < ::Rails::Engine
    config.to_prepare do
      ActiveSupport.on_load :action_controller do
        require 'sitemplate_wysihat/extensions/application_controller_extensions'
        ApplicationController.send :include, ::SitemplateWysihat::ApplicationControllerExtensions
      end
    end
  end
end
