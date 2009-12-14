require 'generic_support'

module MerbAdmin
  class AbstractModel
    # Returns all models for a given Merb app
    def self.all
      @models = []
      orm = Merb.orm
      case orm
      when :active_record, :sequel
        Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |filename|
          File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten.each do |model_name|
            add_model(model_name)
          end
        end
      when :datamapper
        DataMapper::Model.descendants.each do |model|
          add_model(model.to_s)
        end
      else
        raise "MerbAdmin does not support the #{orm} ORM"
      end
      @models.sort!{|x, y| x.model.to_s <=> y.model.to_s}
    end

    def self.add_model(model_name)
      model = lookup(model_name)
      @models << new(model) if model
    end

    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      return nil if MerbAdmin[:excluded_models].include?(model_name)
      begin
        model = Object.full_const_get(model_name)
      rescue NameError
        raise "MerbAdmin could not find model #{model_name}"
      end

      case Merb.orm
      when :active_record
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
      when :active_record
        require 'active_record_support'
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
