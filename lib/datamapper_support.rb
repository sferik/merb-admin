require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'

module MerbAdmin
  class AbstractModel
    module DatamapperSupport
      def get(id)
        model.get(id).extend(InstanceMethods)
      end

      def count(options = {})
        model.count(options.reject{|key, value| [:sort, :sort_reverse].include?(key)})
      end

      def first(options = {})
        model.first(merge_order(options)).extend(InstanceMethods)
      end

      def all(options = {})
        model.all(merge_order(options))
      end

      def paginated(options = {})
        page = options.delete(:page) || 1
        per_page = options.delete(:per_page) || MerbAdmin[:per_page]

        page_count = (count(options).to_f / per_page).ceil

        options.merge!({
          :limit => per_page,
          :offset => (page - 1) * per_page
        })

        [page_count, all(options)]
      end

      def create(params = {})
        model.create(params).extend(InstanceMethods)
      end

      def new(params = {})
        model.new(params).extend(InstanceMethods)
      end

      def destroy_all!
        model.all.destroy!
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
        model.relationships.to_a.map do |name, association|
          {
            :name => name,
            :pretty_name => name.to_s.gsub("_", " ").capitalize,
            :type => association_type_lookup(association),
            :parent_model => association.parent_model,
            :parent_key => association.parent_key.map{|r| r.name},
            :child_model => association.child_model,
            :child_key => association.child_key.map{|r| r.name},
          }
        end
      end

      def properties
        model.properties.map do |property|
          {
            :name => property.name,
            :pretty_name => property.name.to_s.gsub(/_id$/, "").gsub("_", " ").capitalize,
            :type => type_lookup(property),
            :length => property.length,
            :nullable? => property.allow_nil?,
            :serial? => property.serial?,
          }
        end
      end

      private

      def merge_order(options)
        @sort ||= options.delete(:sort) || :id
        @sort_order ||= options.delete(:sort_reverse) ? :desc : :asc
        options.merge(:order => [@sort.to_sym.send(@sort_order)])
      end

      def association_type_lookup(association)
        if self.model == association.parent_model
          association.options[:max] > 1 ? :has_many : :has_one
        elsif self.model == association.child_model
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
          DataMapper::Types::ParanoidDateTime => :datetime,
          DataMapper::Types::Serial => :integer,
          DataMapper::Types::Text => :text,
          Date => :date,
          DateTime => :datetime,
          Fixnum => :integer,
          Float => :float,
          Integer => :integer,
          String => :string,
          Time => :time,
        }
        type[property.type] || type[property.primitive]
      end

      module InstanceMethods
        def update_attributes(attributes)
          update(attributes)
        end
      end

    end
  end
end
