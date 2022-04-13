# frozen_string_literal: true

module Simpler
  class Controller
    BAD_RESPONSE = 'Wrong path, check mistakes in the pathname'.freeze

    attr_reader :name, :headers, :params

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
      @params = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action


      path, @params[:id] = split_path(@request.env["PATH_INFO"])
      params = @request.env['QUERY_STRING']
      add_params(params) unless params.empty?
     
      send(action)
      set_headers
      set_params
      write_response

      @response.finish
    end

    def render(template = nil, plain: nil)
      @request.env['simpler.template'] = template
      @request.env['simpler.plain'] = plain
    end

    def status(status)
      @response.status = status
    end

    def bad_response
      status 404
      @response.write(BAD_RESPONSE)
      
      @response.finish
    end

    private

    def set_params
      @params.each { |key, value| @request.params[key] = value}
    end

    def set_headers 
      set_default_headers

      @headers.each { |key, value| @response[key] = value}
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def split_path(path)
      path, id = path.split('/')[1..]
      [path + '/', id]
    end

    def add_params(params)
      key, value = params.split('=')
      @params[key] = value
    end
  end
end
