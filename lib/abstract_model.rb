require 'generic_support'

module MerbAdmin
  class AbstractModel
    # Returns all models for a given Merb app
    def self.all
      return @models if @models
      @models ||= []
      case Merb.orm
      when :activerecord
        Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |filename|
          # FIXME: This heuristic for finding ActiveRecord models could be too strict
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
      when :sequel
        Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |filename|
          # FIXME: This heuristic for finding Sequel models could be too strict
          File.read(filename).scan(/^class ([\w\d_\-:]+) < Sequel::Model$/).flatten.each do |m|
            model = lookup(m.to_s.to_sym)
            @models << new(model) if model
          end
        end
        @models.sort!{|a, b| a.model.to_s <=> b.model.to_s}
      else
        raise "MerbAdmin does not support the #{Merb.orm} ORM"
      end
    end

    # Given a symbol +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      begin
        model = Object.full_const_get(model_name.to_s)
      rescue NameError
        raise "MerbAdmin could not find model #{model_name}"
      end

      case Merb.orm
      when :activerecord
        return model if superclasses(model).include?(ActiveRecord::Base)
      when :datamapper
        return model if model.include?(DataMapper::Resource)
      when :sequel
        return model if superclasses(model).include?(Sequel::Model)
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
        require 'activerecord_support'
        self.extend(ActiverecordSupport)
      when :datamapper
        require 'datamapper_support'
        self.extend(DatamapperSupport)
      when :sequel
        require 'sequel_support'
        self.extend(SequelSupport)
      else
        raise "MerbAdmin does not support the #{Merb.orm} ORM"
      end
    end

    private

    def self.superclasses(klass)
      superclasses = []
      while klass
        superclasses << klass.superclass if klass && klass.superclass
        klass = klass.superclass
      end
      superclasses
    end

  end
end
