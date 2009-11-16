require 'sequel'
require 'sequel/extensions/pagination'

class Sequel::Model
=begin
  # Intialize each column to the default value for new model objects
  def after_initialize
    super
    model.columns.each do |x|
      if !@values.include?(x) && db_schema[x][:allow_null]
        send("#{x}=", db_schema[x][:ruby_default])
      end
    end
  end
=end

  # Return an empty array for *_to_many association methods for new model objects
  def _load_associated_objects(opts)
    opts.returns_array? && new? ? [] : super
  end
end

module MerbAdmin
  class AbstractModel
    module SequelSupport
      def get(id)
        model.first(:id => id).extend(InstanceMethods)
      end

      def count(options = {})
        if options[:conditions] && !options[:conditions].empty?
          model.where(options[:conditions]).count
        else
          model.count
        end
      end

      def first(options = {})
        sort = options.delete(:sort) || :id
        sort_order = options.delete(:sort_reverse) ? :desc : :asc

        if options[:conditions] && !options[:conditions].empty?
          model.order(sort.to_sym.send(sort_order)).first(options[:conditions]).extend(InstanceMethods)
        else
          model.order(sort.to_sym.send(sort_order)).first.extend(InstanceMethods)
        end
      end

      def all(options = {})
        offset = options.delete(:offset)
        limit = options.delete(:limit)

        sort = options.delete(:sort) || :id
        sort_order = options.delete(:sort_reverse) ? :desc : :asc

        if options[:conditions] && !options[:conditions].empty?
          model.where(options[:conditions]).order(sort.to_sym.send(sort_order))
        else
          model.order(sort.to_sym.send(sort_order))
        end
      end

      def paginated(options = {})
        page = options.delete(:page) || 1
        per_page = options.delete(:per_page) || MerbAdmin[:per_page]
        page_count = (count(options).to_f / per_page).ceil

        sort = options.delete(:sort) || :id
        sort_order = options.delete(:sort_reverse) ? :desc : :asc

        if options[:conditions] && !options[:conditions].empty?
          [page_count, model.paginate(page.to_i, per_page).where(options[:conditions]).order(sort.to_sym.send(sort_order))]
        else
          [page_count, model.paginate(page.to_i, per_page).order(sort.to_sym.send(sort_order))]
        end
      end

      def create(params = {})
        model.create(params).extend(InstanceMethods)
      end

      def new(params = {})
        model.new(params).extend(InstanceMethods)
      end

      def destroy_all!
        model.destroy
      end

      def has_many_associations
        associations.select do |association|
          association[:type] == :has_many
        end
      end

      def has_one_associations
        associations.select do |association|
          association[:type] == :has_one
        end
      end

      def belongs_to_associations
        associations.select do |association|
          association[:type] == :belongs_to
        end
      end

      def associations
        model.all_association_reflections.map do |association|
          {
            :name => association_name_lookup(association),
            :pretty_name => association_pretty_name_lookup(association),
            :type => association_type_lookup(association),
            :parent_model => association_parent_model_lookup(association),
            :parent_key => association_parent_key_lookup(association),
            :child_model => association_child_model_lookup(association),
            :child_key => association_child_key_lookup(association),
          }
        end
      end

      def properties
        model.columns.map do |property|
          {
            :name => property,
            :pretty_name => property.to_s.gsub(/_id$/, "").gsub("_", " ").capitalize,
            :type => property_type_lookup(property),
            :length => property_length_lookup(property),
            :nullable? => model.db_schema[property][:allow_null],
            :serial? => model.db_schema[property][:primary_key],
          }
        end
      end

      private

      def property_type_lookup(property)
        case model.db_schema[property][:db_type]
        when /\A(?:medium|small)?int(?:eger)?(?:\((?:\d+)\))?\z/io
          :integer
        when /\Atinyint(?:\((\d+)\))?\z/io
          :boolean
        when /\Abigint(?:\((?:\d+)\))?\z/io
          :integer
        when /\A(?:real|float|double(?: precision)?)\z/io
          :float
        when 'boolean'
          :boolean
        when /\A(?:(?:tiny|medium|long|n)?text|clob)\z/io
          :text
        when 'date'
          :date
        when /\A(?:small)?datetime\z/io
          :datetime
        when /\Atimestamp(?: with(?:out)? time zone)?\z/io
          :datetime
        when /\Atime(?: with(?:out)? time zone)?\z/io
          :time
        when /\An?char(?:acter)?(?:\((\d+)\))?\z/io
          :string
        when /\A(?:n?varchar|character varying|bpchar|string)(?:\((\d+)\))?\z/io
          :string
        when /\A(?:small)?money\z/io
          :big_decimal
        when /\A(?:decimal|numeric|number)(?:\((\d+)(?:,\s*(\d+))?\))?\z/io
          :big_decimal
        when 'year'
          :integer
        else
          :string
        end
      end

      def property_length_lookup(property)
        case model.db_schema[property][:db_type]
        when /\An?char(?:acter)?(?:\((\d+)\))?\z/io
          $1 ? $1.to_i : 255
        when /\A(?:n?varchar|character varying|bpchar|string)(?:\((\d+)\))?\z/io
          $1 ? $1.to_i : 255
        else
          nil
        end
      end

      def association_name_lookup(association)
        case association[:type]
        when :one_to_many
          if association[:one_to_one]
            association[:name].to_s.singularize.to_sym
          else
            association[:name]
          end
        when :many_to_one
          association[:name]
        else
          raise "Unknown association type"
        end
      end

      def association_pretty_name_lookup(association)
        case association[:type]
        when :one_to_many
          if association[:one_to_one]
            association[:name].to_s.singularize.gsub('_', ' ').capitalize
          else
            association[:name].to_s.gsub('_', ' ').capitalize
          end
        when :many_to_one
          association[:name].to_s.gsub('_', ' ').capitalize
        else
          raise "Unknown association type"
        end
      end

      def association_type_lookup(association)
        case association[:type]
        when :one_to_many
          if association[:one_to_one]
            :has_one
          else
            :has_many
          end
        when :many_to_one
          :belongs_to
        else
          raise "Unknown association type"
        end
      end

      def association_parent_model_lookup(association)
        case association[:type]
        when :one_to_many
          association[:model]
        when :many_to_one
          Object.const_get(association[:class_name])
        else
          raise "Unknown association type"
        end
      end

      def association_parent_key_lookup(association)
        [:id]
      end

      def association_child_model_lookup(association)
        case association[:type]
        when :one_to_many
          Object.const_get(association[:class_name])
        when :many_to_one
          association[:model]
        else
          raise "Unknown association type"
        end
      end

      def association_child_key_lookup(association)
        case association[:type]
        when :one_to_many
          association[:keys]
        when :many_to_one
          ["#{association[:class_name].snake_case}_id".to_sym]
        else
          raise "Unknown association type"
        end
      end

      module InstanceMethods
        def update_attributes(attributes)
          update(attributes)
        end
      end

    end
  end
end
