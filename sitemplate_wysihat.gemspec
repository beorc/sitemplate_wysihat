$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sitemplate_wysihat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sitemplate_wysihat"
  s.version     = SitemplateWysihat::VERSION
  s.authors     = ["beorc"]
  s.email       = ["beorc@inbox.ru"]
  s.homepage    = "http://github.com/beorc/sitemplate_wysihat"
  s.summary     = "sitemplate_wysihat-#{s.version}"
  s.description = "WYSIWYG editor based on JQuery version of Wysihat editor."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'simple_form'
  s.add_dependency 'rmagick'
end
