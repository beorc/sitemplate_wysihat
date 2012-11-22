class SitemplateWysihat::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates/', __FILE__)

  def copy_migrations
    rake "sitemplate_wysihat_engine:install:migrations"
  end

  def copy_engine
    copy_file 'jq-wysihat.js', 'public/jq-wysihat.js'
  end

  def add_routes
    route 'draw_sitemplate_wysihat_routes'
  end

  def copy_configuration
    copy_file "initializer.rb", "config/initializers/sitemplate_wysihat.rb"
  end

  def add_assets
    filename = 'app/assets/javascripts/application.js'
    if File.exist? filename
      File.open(filename) do |io|
        str = '//= require sitemplate_wysihat'
        append_file(filename, str) if io.grep(str).blank?
      end
    end

    filename = 'app/assets/stylesheets/application.css.scss'
    if File.exist? filename
      File.open(filename) do |io|
        str = '@import "sitemplate_wysihat";'
        append_file(filename, str) if io.grep(str).blank?
      end
    end
  end
end
