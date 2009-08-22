require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a model exists" do
  @model_name = 'Player'
  @model = eval(@model_name)
  @model.all.destroy!
end

given "an instance exists" do
  @model_name = 'Player'
  @model = eval(@model_name)
  @model.all.destroy!
  @instance = @model.gen
end

given "two instances exist" do
  @model_name = 'Player'
  @model = eval(@model_name)
  @model.all.destroy!
  @instances = 2.times{@model.gen}
end

given "twenty instances exist" do
  @model_name = 'Player'
  @model = eval(@model_name)
  @model.all.destroy!
  @instances = 20.times{@model.gen}
end

describe "MerbAdmin" do

  before(:each) do
    mount_slice
  end

  describe "dashboard" do
    before(:each) do
      @response = request(url(:admin_dashboard))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should should contain \"Site administration\"" do
      @response.body.should contain("Site administration")
    end
  end

  describe "list", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => @model_name.snake_case))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Select model to edit\"" do
      @response.body.should contain("Select #{@model_name.snake_case.gsub('_', ' ')} to edit")
    end
  end

  describe "list with query", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:query => "Jackie Robinson"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"results\"" do
      @response.body.should contain("results")
    end
  end

  describe "list with boolean filter", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:filter => {:injured => true}})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "list with enum filter", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:filter => {:sex => :male}})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "list with sort", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:query => "Jackie Robinson"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"results\"" do
      @response.body.should contain("results")
    end
  end

  describe "list with 2 instances", :given => "two instances exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => @model_name.snake_case))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"2 results\"" do
      @response.body.should contain("2 #{@model_name.snake_case.gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 2 instances, show all", :given => "two instances exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:all => true})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"2 results\"" do
      @response.body.should contain("2 #{@model_name.snake_case.gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 20 instances", :given => "twenty instances exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => @model_name.snake_case))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"20 results\"" do
      @response.body.should contain("20 #{@model_name.snake_case.gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 20 instances, page 8", :given => "twenty instances exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:page => 8})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"20 results\"" do
      @response.body.should contain("20 #{@model_name.snake_case.gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 20 instances, page 17", :given => "twenty instances exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => @model_name.snake_case), :params => {:page => 17})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"20 results\"" do
      @response.body.should contain("20 #{@model_name.snake_case.gsub('_', ' ').pluralize}")
    end
  end

  describe "new", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_new, :model_name => @model_name.snake_case))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"New model\"" do
      @response.body.should contain("New #{@model_name.snake_case.gsub('_', ' ')}")
    end
  end

  describe "edit", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_edit, :model_name => @model_name.snake_case, :id => @instance.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Edit model\"" do
      @response.body.should contain("Edit #{@model_name.snake_case.gsub('_', ' ')}")
    end
  end

  describe "create", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => @model_name.snake_case), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}})
    end

    it "should create a new instance" do
      @model.first.should_not be_nil
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => @model_name.snake_case))
    end
  end

  describe "create and edit", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => @model_name.snake_case), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_continue => true})
    end

    it "should create a new instance" do
      @model.first.should_not be_nil
    end

    it "should redirect to edit" do
      @response.should redirect_to(url(:admin_edit, :model_name => @model_name.snake_case, :id => @model.first.id))
    end
  end

  describe "create and add another", :given => "a model exists" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => @model_name.snake_case), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_add_another => true})
    end

    it "should create a new instance" do
      @model.first.should_not be_nil
    end

    it "should redirect to new" do
      @response.should redirect_to(url(:admin_new, :model_name => @model_name.snake_case))
    end
  end

  describe "update", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => @model_name.snake_case, :id => @instance.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}})
    end

    it "should update an instance that already exists" do
      @model.first(:id => @instance.id).name.should eql("Jackie Robinson")
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => @model_name.snake_case))
    end
  end

  describe "update and edit", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => @model_name.snake_case, :id => @instance.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_continue => true})
    end

    it "should update an instance that already exists" do
      @model.first(:id => @instance.id).name.should eql("Jackie Robinson")
    end

    it "should redirect to edit" do
      @response.should redirect_to(url(:admin_edit, :model_name => @model_name.snake_case, :id => @instance.id))
    end
  end

  describe "update and add another", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => @model_name.snake_case, :id => @instance.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_add_another => true})
    end

    it "should update an instance that already exists" do
      @model.first(:id => @instance.id).name.should eql("Jackie Robinson")
    end

    it "should redirect to new" do
      @response.should redirect_to(url(:admin_new, :model_name => @model_name.snake_case))
    end
  end

  describe "delete", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_delete, :model_name => @model_name.snake_case, :id => @instance.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Delete model\"" do
      @response.body.should contain("Delete #{@model_name.snake_case.gsub('_', ' ')}")
    end
  end

  describe "destroy", :given => "an instance exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => @model_name.snake_case, :id => @instance.id), :method => "delete")
    end

    it "should destroy an instance" do
      @model.first(:id => @instance.id).should be_nil
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => @model_name.snake_case))
    end
  end

end
