module MerbAdmin
  class AbstractModel
    module DatamapperSupport
      def count(options = {})
        model.count(options)
      end

      def find_all(options = {})
        model.all(options)
      end

      def find(id)
        model.get(id).extend(InstanceMethods)
      end

      def new(params = {})
        model.new(params).extend(InstanceMethods)
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
        model.relationships.to_a.map do |name, relationship|
          {
            :name => name,
            :pretty_name => name.to_s.gsub('_', ' '),
            :type => association_type_lookup(relationship),
            :parent_model => relationship.parent_model,
            :parent_key => relationship.parent_key.map{|r| r.name},
            :child_model => relationship.child_model,
            :child_key => relationship.child_key.map{|r| r.name},
            :remote_relationship => relationship.options[:remote_relationship_name],
            :near_relationship => relationship.options[:near_relationship_name],
          }
        end
      end

      def properties
        model.properties.map do |property|
          {
            :name => property.name,
            :pretty_name => property.field.gsub('_', ' '),
            :type => type_lookup(property),
            :length => property.length,
            :nullable? => property.nullable?,
            :serial? => property.serial?,
            :key? => property.key?,
            :flag_map => property.type.respond_to?(:flag_map) ? property.type.flag_map : nil,
          }
        end
      end

      private

      def association_type_lookup(relationship)
        if self.model == relationship.parent_model
          relationship.options[:max] > 1 ? :has_many : :has_one
        elsif self.model == relationship.child_model
          :belongs_to
        else
          raise "Unknown association type"
        end
      end

      def type_lookup(property)
        type = {
          BigDecimal => :big_decimal,
          DataMapper::Types::Boolean => :boolean,
          DataMapper::Types::ParanoidBoolean => :boolean,
          DataMapper::Types::ParanoidDateTime => :date_time,
          DataMapper::Types::Serial => :integer,
          DataMapper::Types::Text => :text,
          Date => :date,
          DateTime => :date_time,
          Fixnum => :integer,
          Float => :float,
          Integer => :integer,
          String => :string,
          Time => :time,
          TrueClass => :boolean,
        }
        type[property.type] || type[property.primitive]
      end

      module InstanceMethods
        def clear_association(association)
          association.clear
        end
      end

    end
  end
end
