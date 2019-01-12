require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      set_render_type
      send(action)
      write_response

      @response.finish
    end

    def set_header(type, value)
      @response[type] = value
    end

    def set_response_status(status)
      @response.status = status
    end

    def set_render_type
      template = @request.env['simpler.template']
      if template.is_a? Hash
        case template.keys.first
        when :text
          set_header('Content-Type', Rack::Mime.mine_type('.text'))
        else
          set_header('Content-Type', Rack::Mime.mine_type('.html'))
        end
      end
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      renderer = View.renderer(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def request_params
      @request.params.update(@request.env['simpler.route_params'])
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
