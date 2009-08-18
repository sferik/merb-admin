require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe  "MerbAdmin::Forms (controller)" do

  before(:each) do
    mount_slice
    @model_name = 'Player'
    @model = eval(@model_name)
    @model.all.destroy!
  end

  it "should have access to the slice module" do
    controller = dispatch_to(MerbAdmin::Forms, :index)
    controller.slice.should == MerbAdmin
    controller.slice.should == MerbAdmin::Forms.slice
  end

  it "should have an index action" do
    controller = dispatch_to(MerbAdmin::Forms, :index)
    controller.status.should == 200
    controller.body.should contain("Site administration")
  end

  it "should have a list action" do
    controller = dispatch_to(MerbAdmin::Forms, :list, :model_name => @model_name)
    controller.status.should == 200
    controller.body.should contain("Select #{@model_name.snake_case.gsub('_', ' ')} to edit")
  end

  it "should have a new action" do
    controller = dispatch_to(MerbAdmin::Forms, :new, :model_name => @model_name)
    controller.status.should == 200
    controller.body.should contain("New #{@model_name.snake_case.gsub('_', ' ')}")
  end

  it "should have an edit action" do
    @instance = @model.gen
    controller = dispatch_to(MerbAdmin::Forms, :edit, {:model_name => @model_name, :id => @instance.id})
    controller.status.should == 200
    controller.body.should contain("Edit #{@model_name.snake_case.gsub('_', ' ')}")
  end

  it "should have a create action" do
    pending
  end

  it "should have an update action" do
    pending
  end

  it "should have a delete action" do
    @instance = @model.gen
    controller = dispatch_to(MerbAdmin::Forms, :delete, {:model_name => @model_name, :id => @instance.id})
    controller.status.should == 200
    controller.body.should contain("Delete #{@model_name.snake_case.gsub('_', ' ')}")
  end

  it "should have a destroy action" do
    pending
  end

  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAdmin::Forms, :index)
    controller.public_path_for(:image).should == "/slices/merb-admin/images"
    controller.public_path_for(:javascript).should == "/slices/merb-admin/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-admin/stylesheets"
    
    controller.image_path.should == "/slices/merb-admin/images"
    controller.javascript_path.should == "/slices/merb-admin/javascripts"
    controller.stylesheet_path.should == "/slices/merb-admin/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbAdmin::Forms._template_root.should == MerbAdmin.dir_for(:view)
    MerbAdmin::Forms._template_root.should == MerbAdmin::Application._template_root
  end

end
