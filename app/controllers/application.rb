class MerbAdmin::Application < Merb::Controller  
  include Merb::MerbAdmin::MainHelper

  controller_for_slice

end
