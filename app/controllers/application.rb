require 'dm-core'

class MerbAdmin::Application < Merb::Controller
  
  controller_for_slice

  before :set_model, :exclude => "index"

  def set_model
    @model_name = params[:model_name].to_s.camel_case.singularize
    begin
      @model = eval(@model_name)
    rescue StandardError
      raise NotFound
    end
    @properties = @model.properties.to_a
  end

end
