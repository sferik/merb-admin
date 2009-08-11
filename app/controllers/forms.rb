class MerbAdmin::Forms < MerbAdmin::Application
  layout :form

  def index
    @models = DataMapper::Resource.descendants.to_a.sort{|a, b| a.to_s <=> b.to_s}
    # remove DataMapperSessionStore because it's included by default
    @models -= [Merb::DataMapperSessionStore] if Merb.const_defined?(:DataMapperSessionStore)
    render(:layout => "dashboard")
  end

  def list
    options = {}
    filters = params[:filter] || {}
    filters.each_pair do |key, value|
      if @model.properties[key].primitive.to_s == "TrueClass"
        options.merge!(key.to_sym => (value == "true" ? true : false))
      elsif @model.properties[key].primitive.to_s == "Integer" && @model.properties[key].type.respond_to?(:flag_map)
        options.merge!(key.to_sym => value.to_sym)
      end
    end
    if params[:all]
      options = {
        :limit => 200,
      }.merge(options)
      @instances = @model.all(options).reverse
    else
      if params[:query]
        condition_statement = []
        conditions = []
        @properties.each do |property|
          next unless property.primitive.to_s == "String"
          condition_statement << "#{property.field} LIKE ?"
          conditions << "%#{params[:query]}%"
        end
        conditions.unshift(condition_statement.join(" OR "))
        options.merge!(:conditions => conditions) unless conditions == [""]
      end
      if params[:sort]
        order = "[:#{params[:sort]}.#{params[:sort_reverse] ? 'desc' : 'asc'}]"
        options.merge!(:order => eval(order))
      end

      # monkey patch pagination
      @model.class_eval("is_paginated") unless @model.respond_to?(:paginated)
      @current_page = (params[:page] || 1).to_i
      options = {
        :page => @current_page,
        :per_page => 100,
      }.merge(options)
      @page_count, @instances = @model.paginated(options)
      options.delete(:page)
      options.delete(:per_page)
    end
    @record_count = @model.count(options)
    render(:layout => "list")
  end

  def new
    @instance = @model.new
    render(:layout => "form")
  end

  def edit(id)
    @instance = @model.get(id)
    raise NotFound unless @instance
    render(:layout => "form")
  end

  def create
    instance = eval("params[:#{@model_name.snake_case}]")
    @instance = @model.new(instance)
    if @instance.save
      if params[:_continue]
        redirect slice_url(:admin_edit, :model_name => @model_name.snake_case, :id => @instance.id), :message => {:notice => "#{@model_name} was successfully created"}
      elsif params[:_add_another]
        redirect slice_url(:admin_new, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully created"}
      else
        redirect slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully created"}
      end
    else
      message[:error] = "#{@model_name} failed to be created"
      render(:new, :layout => "form")
    end
  end

  def update(id)
    instance = eval("params[:#{@model_name.snake_case}]")
    @instance = @model.get(id)
    raise NotFound unless @instance
    if @instance.update_attributes(instance)
      if params[:_continue]
        redirect slice_url(:admin_edit, :model_name => @model_name.snake_case, :id => @instance.id), :message => {:notice => "#{@model_name} was successfully updated"}
      elsif params[:_add_another]
        redirect slice_url(:admin_new, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully updated"}
      else
        redirect slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully updated"}
      end
    else
      message[:error] = "#{@model_name} failed to be updated"
      render(:edit, :layout => "form")
    end
  end

  def delete(id)
    @instance = @model.get(id)
    raise NotFound unless @instance
    render(:layout => "form")
  end

  def destroy(id)
    @instance = @model.get(id)
    raise NotFound unless @instance
    if @instance.destroy
      redirect slice_url(:admin_list, :model_name => @model_name.snake_case), :message => {:notice => "#{@model_name} was successfully destroyed"}
    else
      raise InternalServerError
    end
  end

end
