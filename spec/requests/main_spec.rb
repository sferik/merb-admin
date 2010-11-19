# -*- encoding: utf-8 -*-
require File.expand_path('../../spec_helper', __FILE__)

describe "MerbAdmin" do
  before(:each) do
    mount_slice
    MerbAdmin::AbstractModel.new("Draft").destroy_all!
    MerbAdmin::AbstractModel.new("Player").destroy_all!
    MerbAdmin::AbstractModel.new("Team").destroy_all!
    MerbAdmin::AbstractModel.new("Division").destroy_all!
    MerbAdmin::AbstractModel.new("League").destroy_all!
  end

  describe "dashboard" do
    before(:each) do
      @response = visit(url(:merb_admin_dashboard))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"Site administration\"" do
      @response.body.should contain("Site administration")
    end
  end

  describe "dashboard with excluded models" do
    before(:each) do
      MerbAdmin[:excluded_models] = ["Player"]
      @response = visit(url(:merb_admin_dashboard))
      MerbAdmin[:excluded_models] = []
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should not contain excluded models" do
      @response.body.should_not contain(/Player/)
    end
  end

  describe "list" do
    before(:each) do
      @response = visit(url(:merb_admin_list, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"Select model to edit\"" do
      @response.body.should contain("Select player to edit")
    end

    it "should show filters" do
      @response.body.should contain(/Filter\n\s*By Retired\n\s*All\n\s*Yes\n\s*No\n\s*By Injured\n\s*All\n\s*Yes\n\s*No/)
    end

    it "should show column headers" do
      @response.body.should contain(/Id\n\s*Created at\n\s*Updated at\n\s*Team\n\s*Name\n\s*Position\n\s*Number\n\s*Retired\n\s*Injured\n\s*Born on\n\s*Notes/)
    end
  end

  describe "list with sort" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Brooklyn Dodgers", :manager => "Walter Alston", :founded => 1883, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 32, :name => "Sandy Koufax", :position => "Starting pitcher")
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :sort => "name")
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should be sorted correctly" do
      @response.body.should contain(/Jackie Robinson.*Sandy Koufax/m)
    end
  end

  describe "list with reverse sort" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Brooklyn Dodgers", :manager => "Walter Alston", :founded => 1883, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 32, :name => "Sandy Koufax", :position => "Starting pitcher")
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :sort => "name", :sort_reverse => "true")
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should be sorted correctly" do
      @response.body.should contain(/Sandy Koufax.*Jackie Robinson/m)
    end
  end

  describe "list with query" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Brooklyn Dodgers", :manager => "Walter Alston", :founded => 1883, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 32, :name => "Sandy Koufax", :position => "Starting pitcher")
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :query => "Jackie Robinson")
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Sandy Koufax")
    end
  end

  describe "list with query and boolean filter" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "New York Mets", :manager => "Jerry Manuel", :founded => 1962, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 41, :name => "Tom Seaver", :position => "Starting pitcher", :retired => true, :injured => true)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 14, :name => "Gil Hodges", :position => "First baseman", :retired => true, :injured => false)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 7, :name => "José Reyes", :position => "Shortstop", :retired => false, :injured => true)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :query => "Tom Seaver", :filter => {:injured => "true"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("Tom Seaver")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Gil Hodges")
      @response.body.should_not contain("José Reyes")
      @response.body.should_not contain("David Wright")
    end
  end


  describe "list with boolean filter" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "New York Mets", :manager => "Jerry Manuel", :founded => 1962, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 7, :name => "José Reyes", :position => "Shortstop", :retired => false, :injured => true)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :filter => {:injured => "true"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("José Reyes")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("David Wright")
    end
  end

  describe "list with boolean filters" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "National League")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "National League East")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "New York Mets", :manager => "Jerry Manuel", :founded => 1962, :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 41, :name => "Tom Seaver", :position => "Starting pitcher", :retired => true, :injured => true)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 14, :name => "Gil Hodges", :position => "First baseman", :retired => true, :injured => false)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 7, :name => "José Reyes", :position => "Shortstop", :retired => false, :injured => true)
      MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :filter => {:retired => "true", :injured => "true"})
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("Tom Seaver")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Gil Hodges")
      @response.body.should_not contain("José Reyes")
      @response.body.should_not contain("David Wright")
    end
  end

  describe "list with 2 objects" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @players = []
      (1..2).each do |number|
        @players << MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => number, :name => "Player #{number}")
      end
      MerbAdmin[:per_page] = 1
      @response = visit(url(:merb_admin_list, :model_name => "player"))
      MerbAdmin[:per_page] = 100
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"2 results\"" do
      @response.body.should contain("2 players")
    end
  end

  describe "list with 20 objects" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @players = []
      (1..20).each do |number|
        @players << MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => number, :name => "Player #{number}")
      end
      MerbAdmin[:per_page] = 1
      @response = visit(url(:merb_admin_list, :model_name => "player"))
      MerbAdmin[:per_page] = 100
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"20 results\"" do
      @response.body.should contain("20 players")
    end
  end

  describe "list with 20 objects, page 8" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @players = []
      (1..20).each do |number|
        @players << MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => number, :name => "Player #{number}")
      end
      MerbAdmin[:per_page] = 1
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :page => 8)
      MerbAdmin[:per_page] = 100
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 objects, page 17" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @players = []
      (1..20).each do |number|
        @players << MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => number, :name => "Player #{number}")
      end
      MerbAdmin[:per_page] = 1
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :page => 17)
      MerbAdmin[:per_page] = 100
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "list show all" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @players = []
      (1..2).each do |number|
        @players << MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => number, :name => "Player #{number}")
      end
      MerbAdmin[:per_page] = 1
      @response = visit(url(:merb_admin_list, :model_name => "player"), :get, :all => true)
      MerbAdmin[:per_page] = 100
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "new" do
    before(:each) do
      @response = visit(url(:merb_admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"New model\"" do
      @response.body.should contain("New player")
    end

    it "should show required fields as \"Required\"" do
      @response.body.should contain(/Name\n\s*Required/)
      @response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      @response.body.should contain(/Position\n\s*Optional/)
      @response.body.should contain(/Born on\n\s*Optional/)
      @response.body.should contain(/Notes\n\s*Optional/)
      @response.body.should contain(/Draft\n\s*Optional/)
      @response.body.should contain(/Team\n\s*Optional/)
    end
  end

  describe "new with has-one association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @draft = MerbAdmin::AbstractModel.new("Draft").create(:player_id => @player.id, :team_id => @team.id, :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      @response = visit(url(:merb_admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show associated objects" do
      @response.body.should contain(/DraftDraft #\d+/)
    end
  end

  describe "new with has-many association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @response = visit(url(:merb_admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show associated objects" do
      @response.body.should contain(/TeamTeam 1Team 2Team 3/)
    end
  end

  describe "new with missing label" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @teams[0].id, :number => 1, :name => "Player 1")
      @response = visit(url(:merb_admin_new, :model_name => "player"))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "create" do
    before(:each) do
      visit(url(:merb_admin_new, :model_name => "player"))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save"
      @player = MerbAdmin::AbstractModel.new("Player").last
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and edit" do
    before(:each) do
      visit(url(:merb_admin_new, :model_name => "player"))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save and continue editing"
      @player = MerbAdmin::AbstractModel.new("Player").last
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and add another" do
    before(:each) do
      visit(url(:merb_admin_new, :model_name => "player"))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save and add another"
      @player = MerbAdmin::AbstractModel.new("Player").last
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create with has-one association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @draft = MerbAdmin::AbstractModel.new("Draft").create(:player_id => @player.id, :team_id => @team.id, :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      visit(url(:merb_admin_new, :model_name => "player"))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => 42
      fill_in "Position", :with => "Second baseman"
      fill_in "Draft", :with => @draft.id.to_s
      @response = click_button "Save"
      @player = MerbAdmin::AbstractModel.new("Player").last
      @draft.reload
    end

    it "should create an object with correct associations" do
      @player.draft.should eql(@draft)
    end
  end

  describe "create with has-many association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      visit(url(:merb_admin_new, :model_name => "league"))
      fill_in "Name", :with => "National League"
      fill_in "Teams", :with => @teams[0].id.to_s
      @response = click_button "Save"
      @league = MerbAdmin::AbstractModel.new("League").last
      @teams.each do |team|
        team.reload
      end
    end

    it "should create an object with correct associations" do
      @league.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  describe "create with uniqueness constraint violated" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_new, :model_name => "player"))
      fill_in "Name", :with => @player.name
      fill_in "Number", :with => @player.number.to_s
      fill_in "Position", :with => @player.position
      fill_in "Team", :with => @player.team_id.to_s
      @response = click_button "Save"
    end

    it "should show an error message" do
      @response.body.should contain("There is already a player with that number on this team")
    end
  end

  describe "create with invalid object" do
    before(:each) do
      @response = visit(url(:merb_admin_create, :model_name => "player"), :post, :params => {:player => {}})
    end

    it "should show an error message" do
      @response.body.should contain("Player failed to be created")
    end
  end

  describe "edit" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @response = visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"Edit model\"" do
      @response.body.should contain("Edit player")
    end

    it "should show required fields as \"Required\"" do
      @response.body.should contain(/Name\n\s*Required/)
      @response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      @response.body.should contain(/Position\n\s*Optional/)
      @response.body.should contain(/Born on\n\s*Optional/)
      @response.body.should contain(/Notes\n\s*Optional/)
      @response.body.should contain(/TeamTeam 1\n\s*Optional/)
      @response.body.should contain(/Draft\n\s*Optional/)
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @draft = MerbAdmin::AbstractModel.new("Draft").create(:player_id => @player.id, :team_id => @team.id, :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      @response = visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show associated objects" do
      @response.body.should contain(/DraftDraft #\d+/)
    end
  end

  describe "edit with has-many association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @teams[0].id, :number => 1, :name => "Player 1")
      @response = visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show associated objects" do
      @response.body.should contain(/TeamTeam 1Team 2Team 3/)
    end
  end

  describe "edit with missing object" do
    before(:each) do
      @response = visit(url(:merb_admin_edit, :model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "edit with missing label" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @teams[0].id, :number => 1, :name => "Player 1")
      @response = visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "update" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save"
      @player.reload
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update and edit" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save and continue"
      @player.reload
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update and add another" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save and add another"
      @player.reload
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @draft = MerbAdmin::AbstractModel.new("Draft").create(:player_id => @player.id, :team_id => @team.id, :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "42"
      fill_in "Position", :with => "Second baseman"
      fill_in "Draft", :with => @draft.id.to_s
      @response = click_button "Save"
      @player.reload
      @draft.reload
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end

    it "should update an object with correct associations" do
      @player.draft.should eql(@draft)
    end
  end

  describe "update with has-many association" do
    before(:each) do
      @leagues = []
      (1..2).each do |number|
        @leagues << MerbAdmin::AbstractModel.new("League").create(:name => "League #{number}")
      end
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @leagues[1].id, :name => "Division 1")
      @teams = []
      (1..3).each do |number|
        @teams << MerbAdmin::AbstractModel.new("Team").create(:league_id => @leagues[1].id, :division_id => @division.id, :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      visit(url(:merb_admin_edit, :model_name => "league", :id => @leagues[0].id))
      fill_in "Name", :with => "National League"
      fill_in "Teams", :with => @teams[0].id.to_s
      @response = click_button "Save"
      @leagues[0].reload
    end

    it "should update an object with correct attributes" do
      @leagues[0].name.should eql("National League")
    end

    it "should update an object with correct associations" do
      @leagues[0].teams.should include(@teams[0])
    end

    it "should not update an object with incorrect associations" do
      @leagues[0].teams.should_not include(@teams[1])
      @leagues[0].teams.should_not include(@teams[2])
    end
  end

  describe "update with missing object" do
    before(:each) do
      @response = visit(url(:merb_admin_update, :model_name => "player", :id => 1), :put, {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}})
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_edit, :model_name => "player", :id => @player.id))
      fill_in "Name", :with => "Jackie Robinson"
      fill_in "Number", :with => "a"
      fill_in "Position", :with => "Second baseman"
      @response = click_button "Save"
      @player.reload
    end

    it "should show an error message" do
      @response.body.should contain("Player failed to be updated")
    end
  end

  describe "delete" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      @response = visit(url(:merb_admin_delete, :model_name => "player", :id => @player.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"Delete model\"" do
      @response.body.should contain("Delete player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      @response = visit(url(:merb_admin_delete, :model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @response = visit(url(:merb_admin_delete, :model_name => "league", :id => @league.id))
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "destroy" do
    before(:each) do
      @league = MerbAdmin::AbstractModel.new("League").create(:name => "League 1")
      @division = MerbAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")
      @team = MerbAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => @division.id, :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = MerbAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")
      visit(url(:merb_admin_delete, :model_name => "player", :id => @player.id))
      @response = click_button "Yes, I'm sure"
      @player = MerbAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      @response = visit(url(:merb_admin_destroy, :model_name => "player", :id => 1), :delete)
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end
end
