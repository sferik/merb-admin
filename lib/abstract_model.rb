require 'generic_support'

module MerbAdmin
  class AbstractModel
    # Returns all models for a given Merb app
    def self.all
      return @models if @models
      @models = []
      orm = Merb.orm
      case orm
      when :activerecord, :sequel
        Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |filename|
          File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten.each do |model_name|
            add_model(model_name.to_sym)
          end
        end
      when :datamapper
        DataMapper::Model.descendants.each do |model_name|
          # Remove DataMapperSessionStore because it's included by default
          next if m == Merb::DataMapperSessionStore if Merb.const_defined?(:DataMapperSessionStore)
          add_model(model_name.to_s.to_sym)
        end
      else
        raise "MerbAdmin does not support the #{orm} ORM"
      end
      @models.sort!{|x, y| x.model.to_s <=> y.model.to_s}
    end
    
    def self.add_model(name)
      return if Merb::Slices.config[:merb_admin][:excluded_models].include?(name.to_s.snake_case.to_sym)
      model = lookup(name)
      @models << new(model) if model
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
        model if superclasses(model).include?(ActiveRecord::Base)
      when :datamapper
        model if model.include?(DataMapper::Resource)
      when :sequel
        model if superclasses(model).include?(Sequel::Model)
      else
        nil
      end
    end

    attr_accessor :model

    def initialize(model)
      model = self.class.lookup(model.to_s.camel_case) unless model.is_a?(Class)
      orm = Merb.orm
      @model = model
      self.extend(GenericSupport)
      case orm
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
        raise "MerbAdmin does not support the #{orm} ORM"
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
