class MerbAdmin::Main < MerbAdmin::Application

  before :find_models, :only => ['index']
  before :find_model, :exclude => ['index']
  before :find_object, :only => ['edit', 'update', 'delete', 'destroy']

  def index
    render(:layout => "dashboard")
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
      @objects = @model.all(options).reverse
    else
      # monkey patch pagination
      @model.class_eval("is_paginated") unless @model.respond_to?(:paginated)
      @current_page = (params[:page] || 1).to_i
      options = {
        :page => @current_page,
        :per_page => MerbAdmin[:per_page],
      }.merge(options)
      @page_count, @objects = @model.paginated(options)
      options.delete(:page)
      options.delete(:per_page)
      options.delete(:offset)
      options.delete(:limit)
    end

    @record_count = @model.count(options)
    render(:layout => "list")
  end

  def new
    @object = @model.new
    render(:layout => "form")
  end

  def edit
    render(:layout => "form")
  end

  def create
    object = eval("params[:#{@model_name.snake_case}]") || {}
    @object = @model.new(object)
    if @object.save
      if params[:_continue]
        redirect(slice_url(:admin_edit, :model_name => @model_name.snake_case, :id => @object.id), :message => {:notice => "#{@model_name} was successfully created"})
      elsif params[:_add_another]
        redirect(slice_url(:admin_new, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully created"})
      else
        redirect(slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully created"})
      end
    else
      message[:error] = "#{@model_name} failed to be created"
      render(:new, :layout => "form")
    end
  end

  def update
    object = eval("params[:#{@model_name.snake_case}]") || {}
    if @object.update_attributes(object)
      if params[:_continue]
        redirect(slice_url(:admin_edit, :model_name => @model_name.snake_case, :id => @object.id), :message => {:notice => "#{@model_name} was successfully updated"})
      elsif params[:_add_another]
        redirect(slice_url(:admin_new, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully updated"})
      else
        redirect(slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully updated"})
      end
    else
      message[:error] = "#{@model_name} failed to be updated"
      render(:edit, :layout => "form")
    end
  end

  def delete
    render(:layout => "form")
  end

  def destroy
    if @object.destroy
      redirect(slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully destroyed"})
    else
      raise BadRequest
    end
  end

  private

  def find_models
    @models = DataMapper::Resource.descendants.to_a.sort{|a, b| a.to_s <=> b.to_s}
    # remove DataMapperSessionStore because it's included by default
    @models -= [Merb::DataMapperSessionStore] if Merb.const_defined?(:DataMapperSessionStore)
  end

  def find_model
    @model_name = params[:model_name].camel_case.singularize
    begin
      @model = eval(@model_name)
    rescue StandardError
      raise NotFound
    end
    find_properties
  end

  def find_properties
    @properties = @model.properties.to_a
  end

  def find_object
    @object = @model.get(params[:id])
    raise NotFound unless @object
  end

  def merge_filter(options)
    return unless params[:filter]
    params[:filter].each_pair do |key, value|
      if @model.properties[key].primitive.to_s == "TrueClass"
        options.merge!(key.to_sym => (value == "true"))
      elsif @model.properties[key].primitive.to_s == "Integer" && @model.properties[key].type.respond_to?(:flag_map)
        options.merge!(key.to_sym => value.to_sym)
      end
    end
  end

  def merge_query(options)
    return unless params[:query]
    condition_statement = []
    conditions = []
    @properties.each do |property|
      next unless property.type.to_s == "String"
      condition_statement << "#{property.field} LIKE ?"
      conditions << "%#{params[:query]}%"
    end
    conditions.unshift(condition_statement.join(" OR "))
    options.merge!(:conditions => conditions) unless conditions == [""]
  end

  def merge_sort(options)
    return unless params[:sort]
    order = "[:#{params[:sort]}.#{params[:sort_reverse] ? 'desc' : 'asc'}]"
    options.merge!(:order => eval(order))
  end

end
