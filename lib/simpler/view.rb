# frozen_string_literal: true

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      return plain unless plain.nil?

      template = File.read(template_path)
      @env['simpler.template_path'] = template_path.to_s.split(VIEW_BASE_PATH)[1]

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

    def plain
      @env['simpler.plain']
    end
  end
end
