module MerbAdmin
  class AbstractModel
    module GenericSupport
      def to_param
        model.to_s.snake_case
      end

      def pretty_name
        model.to_s.snake_case.gsub('_', ' ').capitalize
      end
    end
  end
end
