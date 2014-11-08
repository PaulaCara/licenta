$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "licenta/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "licenta"
  s.version     = Licenta::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Licenta."
  s.description = "TODO: Description of Licenta."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
end
