module MerbAdmin
  class AbstractModel
    module GenericSupport
      def singular_name
        model.to_s.snake_case.to_sym
      end

      def plural_name
        model.to_s.snake_case.pluralize.to_sym
      end

      def pretty_name
        model.to_s.snake_case.gsub('_', ' ')
      end
    end
  end
end
