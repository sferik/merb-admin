require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe  "MerbAdmin::Forms (controller)" do

  before(:each) do
    mount_slice
  end

  after(:each) do
    dismount_slice
  end

  it "should have access to the slice module" do
    controller = dispatch_to(MerbAdmin::Forms, :index)
    controller.slice.should == MerbAdmin
    controller.slice.should == MerbAdmin::Forms.slice
  end

  it "should have an index action" do
    controller = dispatch_to(MerbAdmin::Forms, :index)
    controller.status.should == 200
    controller.body.should contain("MerbAdmin")
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
