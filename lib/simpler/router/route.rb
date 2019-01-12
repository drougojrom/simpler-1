module Simpler
  class Router
    class Route

      PATH_REGEX = /(?:\/tests\b)(?:\/[\w]+){2}$/

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match(@path)
      end

    end
  end
end
