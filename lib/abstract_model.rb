require 'generic_support'
require 'activerecord_support'
require 'datamapper_support'

module MerbAdmin
  class AbstractModel
    # Returns all models for a given Merb app
    def self.all
      return @models if @models
      @models ||= []
      case Merb.orm
      when :activerecord
        Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |filename|
          # FIXME: This heuristic for finding ActiveRecord models is too strict
          File.read(filename).scan(/^class ([\w\d_\-:]+) < ActiveRecord::Base$/).flatten.each do |m|
            model = lookup(m.to_s.to_sym)
            @models << new(model) if model
          end
        end
        @models.sort!{|a, b| a.model.to_s <=> b.model.to_s}
      when :datamapper
        DataMapper::Resource.descendants.each do |m|
          # Remove DataMapperSessionStore because it's included by default
          next if m == Merb::DataMapperSessionStore if Merb.const_defined?(:DataMapperSessionStore)
          model = lookup(m.to_s.to_sym)
          @models << new(model) if model
        end
        @models.sort!{|a, b| a.model.to_s <=> b.model.to_s}
      else
        raise "MerbAdmin does not support the #{Merb.orm} ORM"
      end
    end

    # Given a symbol +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      begin
        model = const_get(model_name)
      rescue NameError
        raise "MerbAdmin could not find model #{model_name}"
      end

      case Merb.orm
      when :activerecord
        return model if model.superclass == ActiveRecord::Base
      when :datamapper
        return model if model.include?(DataMapper::Resource)
      end
      nil
    end

    attr_accessor :model

    def initialize(model)
      model = self.class.lookup(model.to_s.camel_case) unless model.is_a?(Class)
      @model = model
      self.extend(GenericSupport)
      case Merb.orm
      when :activerecord
        self.extend(ActiverecordSupport)
      when :datamapper
        self.extend(DatamapperSupport)
      else
        raise "MerbAdmin does not support the #{Merb.orm} ORM"
      end
    end
  end
end
