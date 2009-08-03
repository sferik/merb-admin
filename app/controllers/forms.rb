class MerbAdmin::Forms < MerbAdmin::Application
  layout :form

  def index
    @models = DataMapper::Model.descendants.to_a.sort{|a, b| a.to_s <=> b.to_s} - [Merb::DataMapperSessionStore]
    render(:layout => "dashboard")
  end

  def list
    @instances = @model.all
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
