require 'kaminari'
require 'simple_form'
require 'pundit'
require 'show_for'
require 'ckeditor'
require 'carrierwave'
require 'mini_magick'
require 'meta-tags'

module Btemplater
  class Engine < ::Rails::Engine
    isolate_namespace Btemplater
  end
end
