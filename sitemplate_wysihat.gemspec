$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sitemplate_wysihat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sitemplate_wysihat"
  s.version     = SitemplateWysihat::VERSION
  s.authors     = ["Yury Kotov"]
  s.email       = ["beorc@inbox.ru"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "jquery-rails"
  s.add_dependency 'coffee-rails', '~> 3.2.1'
  s.add_dependency 'compass_twitter_bootstrap'

end
