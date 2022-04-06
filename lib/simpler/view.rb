require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end 

    private

    def template_path
      path = template || [controller.name, action].join('/') # tests/index
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb") 
      # -> how root/ + 'app/views' + tests/index = root/app/views / tests/index.html
      # if Simpler.root.join(VIEW_BASE_PATH, path, ".html") 
      # --- i get root/app/views / tests/index / .html
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end
  end
end