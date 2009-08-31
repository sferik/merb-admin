require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a player exists" do
  @player = Player.gen
end

given "two players exist" do
  @players = []
  2.times do
    @players << Player.gen
  end
end

given "three teams exists" do
  @teams = []
  3.times do
    @teams << Team.gen
  end
end

given "a player exists and three teams exist" do
  @player = Player.gen
  @teams = []
  3.times do
    @teams << Team.gen
  end
end

given "a league exists and three teams exist" do
  @league = League.gen
  @teams = []
  3.times do
    @teams << Team.gen
  end
end

given "twenty players exist" do
  @players = []
  20.times do
    @players << Player.gen
  end
end

describe "MerbAdmin" do

  before(:each) do
    mount_slice
    Player.all.destroy!
    Team.all.destroy!
    Division.all.destroy!
    League.all.destroy!
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
      @response.body.should contain("Select player to edit")
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

    it "should contain right results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain wrong results" do
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

    it "should be ordered rightly" do
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

    it "should be ordered rightly" do
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

    it "should contain right results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain wrong results" do
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

    it "should contain right results" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain wrong results" do
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
      @response.body.should contain("2 players")
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
      @response.body.should contain("20 players")
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

    it "should paginate rightly" do
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

    it "should paginate rightly" do
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
      @response.body.should contain("New player")
    end
  end

  describe "new with has-many association", :given => "three teams exists" do
    before(:each) do
      @response = request(url(:admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end


  describe "edit", :given => "a player exists" do
    before(:each) do
      @response = request(url(:admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Edit model\"" do
      @response.body.should contain("Edit player")
    end
  end

  describe "edit with has-many association", :given => "a player exists and three teams exist" do
    before(:each) do
      @response = request(url(:admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
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
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :position => :second, :sex => :male}})
    end

    it "should redirect to list" do
      @response.should redirect_to(url(:admin_list, :model_name => "player"))
    end

    it "should create a new object" do
      Player.first.should_not be_nil
    end
  end

  describe "create and edit" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :position => :second, :sex => :male}, :_continue => true})
    end

    it "should redirect to edit" do
      @response.should redirect_to(url(:admin_edit, :model_name => "player", :id => Player.first.id))
    end

    it "should create a new object" do
      Player.first.should_not be_nil
    end
  end

  describe "create and add another" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "player"), :method => "post", :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :position => :second, :sex => :male}, :_add_another => true})
    end

    it "should redirect to new" do
      @response.should redirect_to(url(:admin_new, :model_name => "player"))
    end

    it "should create a new object" do
      Player.first.should_not be_nil
    end
  end

  describe "create with has-many association", :given => "three teams exists" do
    before(:each) do
      @response = request(url(:admin_create, :model_name => "league"), :method => "post", :params => {:league => {:name => "National League"}, :associations => {:teams => [@teams[0].id, @teams[1].id]}})
    end

    it "should create a new object" do
      League.first.should_not be_nil
    end

    it "should include right associations" do
      League.first.teams.should include(@teams[0])
      League.first.teams.should include(@teams[1])
    end

    it "should not include wrong associations" do
      League.first.teams.should_not include(@teams[2])
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

  describe "update", :given => "a player exists" do
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

  describe "update and edit", :given => "a player exists" do
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

  describe "update and add another", :given => "a player exists" do
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

  describe "update with has-many association", :given => "a league exists and three teams exist" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "league", :id => @league.id), :method => "put", :params => {:league => {:name => "National League"}, :associations => {:teams => [@teams[0].id, @teams[1].id]}})
    end

    it "should update an object that already exists" do
      League.first(:id => @league.id).name.should eql("National League")
    end

    it "should include right associations" do
      League.first.teams.should include(@teams[0])
      League.first.teams.should include(@teams[1])
    end

    it "should not include wrong associations" do
      League.first.teams.should_not include(@teams[2])
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

  describe "update with invalid object", :given => "a player exists" do
    before(:each) do
      @response = request(url(:admin_update, :model_name => "player", :id => @player.id), :method => "put", :params => {:player => {:number => "a"}})
    end

    it "should contain an error message" do
      @response.body.should contain("Player failed to be updated")
    end
  end

  describe "delete", :given => "a player exists" do
    before(:each) do
      @response = request(url(:admin_delete, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should contain \"Delete model\"" do
      @response.body.should contain("Delete player")
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

  describe "destroy", :given => "a player exists" do
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
