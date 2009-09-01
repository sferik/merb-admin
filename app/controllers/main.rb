require File.join( File.dirname(__FILE__), '..', '..', 'lib', 'abstract_model' )
require File.join( File.dirname(__FILE__), '..', '..', 'lib', 'metaid' )

class MerbAdmin::Main < MerbAdmin::Application
  include Merb::MerbAdmin::MainHelper

  before :find_models, :only => ['index']
  before :find_model, :exclude => ['index']
  before :find_object, :only => ['edit', 'update', 'delete', 'destroy']

  def index
    render(:layout => 'dashboard')
  end

  def list
    options = {}
    merge_filter(options) 
    merge_query(options)
    merge_sort(options)

    if !MerbAdmin[:paginate] || params[:all]
      options = {
        :limit => 200,
      }.merge(options)
      @objects = @abstract_model.find_all(options).reverse
    else
      # monkey patch pagination
      @abstract_model.model.class_eval('is_paginated') unless @abstract_model.model.respond_to?(:paginated)
      @current_page = (params[:page] || 1).to_i
      options = {
        :page => @current_page,
        :per_page => MerbAdmin[:per_page],
      }.merge(options)
      @page_count, @objects = @abstract_model.model.paginated(options)
      options.delete(:page)
      options.delete(:per_page)
      options.delete(:offset)
      options.delete(:limit)
    end

    @record_count = @abstract_model.count(options)
    render(:layout => 'list')
  end

  def new
    @object = @abstract_model.new
    render(:layout => 'form')
  end

  def edit
    render(:layout => 'form')
  end

  def create
    object = params[@abstract_model.singular_name] || {}
    # Delete fields that are blank
    object.each do |key, value|
      object[key] = nil if value.blank?
    end
    has_one_associations = @abstract_model.has_one_associations.map{|association| [association, (params[:associations] || {}).delete(association[:name])]}
    has_many_associations = @abstract_model.has_many_associations.map{|association| [association, (params[:associations] || {}).delete(association[:name])]}
    @object = @abstract_model.new(object)
    if @object.save && has_one_associations.each{|association, id| update_has_one_association(association, id)} && has_many_associations.each{|association, ids| update_has_many_association(association, ids)}
      if params[:_continue]
        redirect(slice_url(:admin_edit, :model_name => @abstract_model.singular_name, :id => @object.id), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully created"})
      elsif params[:_add_another]
        redirect(slice_url(:admin_new, :model_name => @abstract_model.singular_name), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully created"})
      else
        redirect(slice_url(:admin_list, :model_name => @abstract_model.singular_name), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully created"})
      end
    else
      message[:error] = "#{@abstract_model.pretty_name.capitalize} failed to be created"
      render(:new, :layout => 'form')
    end
  end

  def update
    object = params[@abstract_model.singular_name] || {}
    # Delete fields that are blank
    object.each do |key, value|
      object[key] = nil if value.blank?
    end
    has_one_associations = @abstract_model.has_one_associations.map{|association| [association, (params[:associations] || {}).delete(association[:name])]}
    has_many_associations = @abstract_model.has_many_associations.map{|association| [association, (params[:associations] || {}).delete(association[:name])]}
    if @object.update_attributes(object) && has_one_associations.each{|association, id| update_has_one_association(association, id)} && has_many_associations.each{|association, ids| update_has_many_association(association, ids)} 
      if params[:_continue]
        redirect(slice_url(:admin_edit, :model_name => @abstract_model.singular_name, :id => @object.id), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully updated"})
      elsif params[:_add_another]
        redirect(slice_url(:admin_new, :model_name => @abstract_model.singular_name), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully updated"})
      else
        redirect(slice_url(:admin_list, :model_name => @abstract_model.singular_name), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully updated"})
      end
    else
      message[:error] = "#{@abstract_model.pretty_name.capitalize} failed to be updated"
      render(:edit, :layout => 'form')
    end
  end

  def delete
    render(:layout => 'form')
  end

  def destroy
    if @object.destroy
      redirect(slice_url(:admin_list, :model_name => @abstract_model.singular_name), :message => {:notice => "#{@abstract_model.pretty_name.capitalize} was successfully destroyed"})
    else
      raise BadRequest
    end
  end

  private

  def find_models
    @abstract_models = MerbAdmin::AbstractModel.all
  end

  def find_model
    model_name = params[:model_name].camel_case
    @abstract_model = MerbAdmin::AbstractModel.new(model_name)
    find_properties
  end

  def find_properties
    @properties = @abstract_model.properties
  end

  def find_object
    @object = @abstract_model.find(params[:id])
    raise NotFound unless @object
  end

  def merge_filter(options)
    return unless params[:filter]
    params[:filter].each_pair do |key, value|
      @properties.each do |property|
        next unless property[:name] == key.to_sym
        if property[:type] == :boolean
          options.merge!(key.to_sym => (value == 'true'))
        elsif property[:type] == :integer && property[:flag_map]
          options.merge!(key.to_sym => value.to_sym)
        end
      end
    end
  end

  def merge_query(options)
    return unless params[:query]
    condition_statement = []
    conditions = []
    @properties.each do |property|
      next unless property[:type] == :string
      condition_statement << "#{property[:name]} LIKE ?"
      conditions << "%#{params[:query]}%"
    end
    conditions.unshift(condition_statement.join(' OR '))
    options.merge!(:conditions => conditions) unless conditions == ['']
  end

  def merge_sort(options)
    return unless params[:sort]
    options.merge!(:order => [params[:sort].to_sym.send(params[:sort_reverse] ? :desc : :asc)])
  end

  def update_has_one_association(association, id)
    model = MerbAdmin::AbstractModel.new(association[:child_model])
    if object = model.find(id)
      object.update_attributes(association[:child_key] => @object.id)
    end
  end

  def update_has_many_association(association, ids)
    # Remove all of the associated items
    relationship = @object.send(association[:name])
    @object.clear_association(relationship)
    # Add all of the objects to the relationship
    conditions = {association[:parent_key].first => ids}
    model = MerbAdmin::AbstractModel.new(association[:child_model])
    for object in model.find_all(conditions)
      relationship << object
    end
    @object.save
  end

end
