require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'pp'

context "A Post that versions a title and description field" do

  before(:each) do
    #Grit.debug = true
    @hat = Hat.create!(:title => "Moo", :body => "RAR")
    @repo_dir = File.join('/', 'tmp', '.data', 'git_store.git')
  end
  
  it "has the list of versioned fields, on the class" do
    Hat.git_settings.versioned_fields.should == [:title, :body]
  end
  
  describe "on update" do
    it "should write a git tree with the field changes with the /model/id/field.txt format" do
      @hat.title = "hi"
      @hat.body = "there"
      @hat.save!
      dta = (@hat.git.log.first.tree/"hats"/@hat.id.to_s/"title.txt").data
      dta.should == "hi"
      dta = (@hat.git.log.first.tree/"hats"/@hat.id.to_s/"body.txt").data
      dta.should == "there"
    end
    
    it "saves one commit" do
      @hat.title = "yeah!!"
      @hat.body = "wheeeeeeeee!"
      lambda {
        @hat.save!
      }.should change { @hat.git.commits.size }.by(1)
    end
  end

end

context "A Post that versions a title field" do

  before(:each) do
    #Grit.debug = true
    @post = Post.create!(:title => "Moo", :body => "RAR")
    @repo_dir = File.join('/', 'tmp', '.data', 'git_store.git')
  end
  
  describe "in general" do
    it "should have the list of versioned fields, on the class" do
      Post.git_settings.versioned_fields.should == [:title]
    end

    it "should have the git repository to save to, on the class" do
      Post.git_settings.repository.should == @repo_dir
    end

    it "should have the list of versioned fields, on an instance" do
      @post.git_settings.versioned_fields.should == [:title]
    end

    it "should have the git repository to save to, on an instance" do
      @post.git_settings.repository.should == @repo_dir
    end

    it "should read from git" do
      @post.title.should == 'Moo'
      @post.title = 'Moo2'
      @post.title.should == 'Moo2'
    end
    
  end
  
  describe "reverting" do
    it "should roll back all fields to a previous commit" do
      @post.title = "monkey"
      @post.save
      @post.revert_to @post.git.commits[0].id
      @post.title.should == "Moo"
      @post.save!
      @post.reload.title.should == "Moo"
    end
    
    it "reverting to a previous commit-ish creates a new commit" do
      @post.title = "elephant"
      @post.save
      lambda {
        @post.revert_to @post.git.commits[0].id
      }.should change { @post.git.commits.size }.by(1)
    end
  end

  describe "on create" do
    it "should not create a git version of itself" do
      Grit::Repo.expects(:new).times(0)
      p = Post.new
    end
  end

  describe "on update" do
        
    it "should write a git tree with the field changes with the /model/id/field.txt format" do
      t = "This is another new title"
      @post.title = t
      @post.save
      dta = (@post.git.log.first.tree/"posts"/@post.id.to_s/"title.txt").data
      dta.should == t
    end
    
    it "should calculate the fields that have changed" do
      @post.title = "Another Moo"
      @post.title_changed?.should be_true
      @post.changed_versioned_fields.should == [:title]      
    end
    
    it "should list all available version strings for a file as a log" do
      @post.log.should be_kind_of(Array)
      @post.title = "New title to increment the commit count"
      @post.save
      @post.log.should be_kind_of(Array)
    end
    
    it "should increment version counts when updates occur" do
      @post.versions.size.should == 1
      @post.title = "New title to increment the commit count"
      @post.save
      @post.versions.size.should == 2
      @post.title = "Another new title to increment the commit count"
      @post.save
      @post.versions.size.should == 3
    end    
  end
    
  after(:each) do
    FileUtils.rm_rf('/tmp/.data')
  end
    
end
