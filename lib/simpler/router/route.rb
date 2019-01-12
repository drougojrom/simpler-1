module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :route_params, :actions

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @route_params = {}

        add_action(action)
      end

      def match?(method, path)
        app_path_segments = parse_route(@path)
        path_segments = parse_route(path)
        @method == method && match_paths?(app_path_segments, path_segments)
      end

      private

      def add_action(action)
        @actions ||= []
        @actions.push(action)
        @actions = @actions.uniq
      end

      def parse_route(path)
        path.split('/').reject!(&:empty?) || []
      end

      def match_paths?(app_path_segments, path_segments)
        return false if path_segments.size != app_path_segments.size
        app_path_segments.each_with_index do |parameter, index|
          if parameter.start_with?(':') && !@actions.include?(path_segments[index])
            set_params(parameter, path_segments[index])
          elsif parameter != path_segments[index]
            return false
          end
        end
        true
      end

      def set_params(parameter, path_element)
        parameter = parameter.delete(':').to_sym
        @route_params[parameter] = path_element.to_i != 0 ? path_element.to_i : path_element
      end
    end
  end
end
