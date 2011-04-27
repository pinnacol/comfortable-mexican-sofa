require 'comfortable_mexican_sofa'
require 'rails'
require 'paperclip'
require 'active_link_to'
require 'mime/types'

module ComfortableMexicanSofa
  class Engine < ::Rails::Engine
    
    # Must expliclitly mix in helpers to app
    # http://www.ruby-forum.com/topic/211017
    initializer 'engine.helper' do |app|
       ActionView::Base.send :include, ::ComfortableMexicanSofaHelper
     end
     
  end
end

