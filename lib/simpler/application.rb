# frozen_string_literal: true

require 'yaml'
require 'singleton'
require 'sequel'

module Simpler
  class Application
    include Singleton

    attr_reader :db

    def initialize
      require_lib
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def call(env)
      route = @router.route_for(env)

      return Controller.new(env).bad_response if route.nil?

      controller = route.controller.new(env)
      action = route.action

      make_response(controller, action)
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def require_lib
      Dir["#{Simpler.root}/lib/simpler/**/*.rb"].each { |file| require file }
    end

    def make_response(controller, action)
      controller.make_response(action)
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      # database_config['database'] =  Simpler.root.join(database_config['database'])

      @db = Sequel.connect(database_config)
    end
  end
end
