class SitemplateWysihat::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates/', __FILE__)

  def copy_engine
    copy_file 'jq-wysihat.js', 'public/jq-wysihat.js'
  end
end
