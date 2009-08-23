require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "an object exists" do
  @player = Player.gen
end

given "two players exist" do
  @players = 2.times{Player.gen}
end

given "twenty players exist" do
  @players = 20.times{Player.gen}
end

describe "MerbAdmin" do

  before(:each) do
    mount_slice
    Player.all.destroy!
  end

  describe "dashboard" do
    before(:each) do
      @response = request(url(:admin_dashboard))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Site administration\"" do
      @response.body.should contain("Site administration")
    end
  end

  describe "list" do
    before(:each) do
      @response = request(url(:admin_list, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Select model to edit\"" do
      @response.body.should contain("Select #{"player".gsub('_', ' ')} to edit")
    end
  end

  describe "list with query" do
    before(:each) do
      Player.gen(:name => "Jackie Robinson")
      Player.gen(:name => "Sandy Koufax")
      @response = request(url(:admin_list, :model_name => "player"), :params => {:query => "Jackie Robinson"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain matching results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain non-matching results" do
      @response.body.should_not contain("Sandy Koufax")
    end
  end

  describe "list with sort" do
    before(:each) do
      Player.gen(:name => "Jackie Robinson")
      Player.gen(:name => "Sandy Koufax")
      @response = request(url(:admin_list, :model_name => "player"), :params => {:sort => :name})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should be ordered correctly" do
      @response.body.should contain(/Sandy Koufax.*Jackie Robinson/m)
    end
  end

  describe "list with reverse sort" do
    before(:each) do
      Player.gen(:name => "Jackie Robinson")
      Player.gen(:name => "Sandy Koufax")
      @response = request(url(:admin_list, :model_name => "player"), :params => {:sort => :name, :sort_reverse => true})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should be ordered correctly" do
      @response.body.should contain(/Jackie Robinson.*Sandy Koufax/m)
    end
  end

  describe "list with boolean filter" do
    before(:each) do
      Player.gen(:name => "Jackie Robinson", :retired => true)
      Player.gen(:name => "David Wright", :retired => false)
      @response = request(url(:admin_list, :model_name => "player"), :params => {:filter => {:retired => true}})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain matching results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain non-matching results" do
      @response.body.should_not contain("David Wright")
    end
  end

  describe "list with enum filter" do
    before(:each) do
      Player.gen(:name => "Jackie Robinson", :sex => :male)
      Player.gen(:name => "Dottie Hinson", :sex => :female)
      @response = request(url(:admin_list, :model_name => "player"), :params => {:filter => {:sex => :male}})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain matching results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain non-matching results" do
      @response.body.should_not contain("Dottie Hinson")
    end
  end

  describe "list with 2 objects", :given => "two players exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"2 results\"" do
      @response.body.should contain("2 #{"player".gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 20 objects", :given => "twenty players exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"20 results\"" do
      @response.body.should contain("20 #{"player".gsub('_', ' ').pluralize}")
    end
  end

  describe "list with 20 objects, page 8", :given => "twenty players exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => "player"), :params => {:page => 8})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 objects, page 17", :given => "twenty players exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => "player"), :params => {:page => 17})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "list show all", :given => "two players exist" do
    before(:each) do
      MerbAdmin[:paginate] = true
      MerbAdmin[:per_page] = 1
      @response = request(url(:admin_list, :model_name => "player"), :params => {:all => true})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "new" do
    before(:each) do
      @response = request(url(:admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"New model\"" do
      @response.body.should contain("New #{"player".gsub('_', ' ')}")
    end
  end

  describe "edit", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Edit model\"" do
      @response.body.should contain("Edit #{"player".gsub('_', ' ')}")
    end
  end

  describe "edit with missing object" do
    before(:each) do
      @response = request(url(:admin_edit, :model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      @response.status.should == 404
    end
  end

  describe "create" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}})
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => "player"))
    end

    it "should create a new player" do
      Player.first.should_not be_nil
    end
  end

  describe "create and edit" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_continue => true})
    end

    it "should redirect to edit" do
      @response.should redirect_to(url(:admin_edit, :model_name => "player", :id => Player.first.id))
    end

    it "should create a new player" do
      Player.first.should_not be_nil
    end
  end

  describe "create and add another" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_add_another => true})
    end

    it "should redirect to new" do
      @response.should redirect_to(url(:admin_new, :model_name => "player"))
    end

    it "should create a new player" do
      Player.first.should_not be_nil
    end
  end

  describe "create with invalid object" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {}})
    end

    it "should contain an error message" do
      @response.body.should contain("Player failed to be created")
    end
  end

  describe "update", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => @player.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}})
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => "player"))
    end

    it "should update an object that already exists" do
      Player.first(:id => @player.id).name.should eql("Jackie Robinson")
    end
  end

  describe "update and edit", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => @player.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_continue => true})
    end

    it "should redirect to edit" do
      @response.should redirect_to(url(:admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should update an object that already exists" do
      Player.first(:id => @player.id).name.should eql("Jackie Robinson")
    end
  end

  describe "update and add another", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => @player.id), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}, :_add_another => true})
    end

    it "should redirect to new" do
      @response.should redirect_to(url(:admin_new, :model_name => "player"))
    end

    it "should update an object that already exists" do
      Player.first(:id => @player.id).name.should eql("Jackie Robinson")
    end
  end

  describe "update with missing object" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => 1), :method => "put", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :sex => :male}})
    end

    it "should raise NotFound" do
      @response.status.should == 404
    end
  end

  describe "update with invalid object", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => @player.id), :method => "put", :params => {:player => {:number => nil}})
    end

    it "should contain an error message" do
      @response.body.should contain("Player failed to be updated")
    end
  end

  describe "delete", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_delete, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Delete model\"" do
      @response.body.should contain("Delete #{"player".gsub('_', ' ')}")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      @response = request(url(:admin_delete, :model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      @response.status.should == 404
    end
  end

  describe "destroy", :given => "an object exists" do
    before(:each) do
      @response = request(url(:admin_destroy, :model_name => "player", :id => @player.id), :method => "delete")
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => "player"))
    end

    it "should destroy an object" do
      Player.first(:id => @player.id).should be_nil
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      @response = request(url(:admin_destroy, :model_name => "player", :id => 1), :method => "delete")
    end

    it "should raise NotFound" do
      @response.status.should == 404
    end
  end

end
