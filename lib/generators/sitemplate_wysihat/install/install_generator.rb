class SitemplateWysihat::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates/', __FILE__)

  def copy_engine
    copy_file 'jq-wysihat.js', 'public/jq-wysihat.js'
  end

  def add_assets
    filename = 'app/assets/javascripts/application.js'
    File.open(filename) do |io|
      str = '//= require sitemplate_wysihat'
      append_file(filename, str) if io.grep(str).blank?
    end

    filename = 'app/assets/stylesheets/application.css'
    File.open(filename) do |io|
      str = " *= require sitemplate_wysihat\n"
      inject_into_file(filename, str, before: '*/') if io.grep(str).blank?
    end
  end
end
