require 'erb'

class HTMLRenderer
  VIEW_BASE_PATH = 'app/views'.freeze

  def initialize(env)
    @env = env
  end

  def render(binding)
    template = File.read(template_path)

    ERB.new(template).result(binding)
  end

  private

  def controller
    @env['simpler.controller']
  end

  def action
    @env['simpler.action']
  end

  def template
    @env['simpler.template']
  end

  def template_path
    path = [controller.name, action].join('/')
    @env['simpler.template'] = "#{path}.html.erb"

    Simpler.root.join(VIEW_BASE_PATH, template)
  end
end
