require 'generic_support'
require 'datamapper_support'

module MerbAdmin
  class AbstractModel
    # Returns all models for a given Merb app
    def self.all
      return @models if @models
      @models ||= []
      case Merb.orm
      when :datamapper
        DataMapper::Resource.descendants.each do |m|
          # Remove DataMapperSessionStore because it's included by default
          next if m == Merb::DataMapperSessionStore if Merb.const_defined?(:DataMapperSessionStore)
          model = lookup(m.to_s.to_sym)
          @models << new(model) if model
        end
        @models.sort{|a, b| a.to_s <=> b.to_s}
      else
        raise "MerbAdmin does not currently support the #{Merb.orm} ORM"
      end
    end

    # Given a symbol +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      model = const_get(model_name)
      raise "could not find model #{model_name}" if model.nil?
      return model if model.include?(DataMapper::Resource)
      nil
    end

    attr_accessor :model

    def initialize(model)
      model = self.class.lookup(model.camel_case.to_sym) unless model.is_a?(Class)
      @model = model
      self.extend(GenericSupport)
      case Merb.orm
      when :datamapper
        self.extend(DatamapperSupport)
      else
        raise "MerbAdmin does not currently support the #{Merb.orm} ORM"
      end
    end
  end
end
