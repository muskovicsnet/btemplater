$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'btemplater/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'btemplater'
  s.version     = Btemplater::VERSION
  s.authors     = ['egivandor']
  s.email       = ['egivandor82@gmail.com']
  s.homepage    = 'http://muskovics.net'
  s.summary     = 'Bootstrap templater.'
  s.description = 'Bootstrap template helpers.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.4'
  s.add_dependency 'kaminari'
  s.add_dependency 'simple_form'
  s.add_dependency 'pundit'
  s.add_dependency 'show_for'
  s.add_dependency 'ckeditor'
  s.add_dependency 'carrierwave'
  s.add_dependency 'mini_magick'
  s.add_dependency 'meta-tags'

  s.add_development_dependency 'sqlite3'
end
