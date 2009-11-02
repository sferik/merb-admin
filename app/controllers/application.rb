class MerbAdmin::Application < Merb::Controller
  include Merb::MerbAdmin::ApplicationHelper

  controller_for_slice

end
