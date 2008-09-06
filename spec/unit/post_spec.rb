require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'pp'

context "A Post that versions a title field" do

  before(:each) do
    Grit.debug = true
    @post = Post.create(:title => "Moo", :body => "RAR")
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
    
    it "should have a count of zero when no updates have occurred" do
      @post.versions.should == 0
    end
  end

  describe "on create" do
    it "should not create a git version of itself" do
      Grit::Repo.expects(:new).times(0)
      p = Post.new
    end
  end

  describe "on update" do
    
    it "should calculate the fields that have changed" do
      @post.title = "Another Moo"
      @post.changed_versioned_fields.should == [:title]      
    end
    
    it "should write a git tree with the field changes with the /model/id/field.txt format"
        
    it "should add files created to git" do
      @post.title = "This is another new title"
      @post.save
    end

=begin
    it "should commit all changes to git" do
      git_mock = mock
      git_mock.expects(:commit_all).with("new version of Post, id: #{@post.id.to_s}")
      @post.expects(:git).returns(git_mock)
      @post.title = "New Title"
      @post.save
    end
=end
    
    it "should list all available version strings for a file as a log" do
      @post.log.should be_kind_of(Array)
      @post.title = "New title to increment the commit count"
      @post.save
      @post.log.should be_kind_of(Array)
      pp @post.log
    end
    
    it "should increment version counts when updates occur" do
      @post.title = "New title to increment the commit count"
      @post.save
      @post.versions.should == 1
      @post.title = "Another new title to increment the commit count"
      @post.save
      @post.versions.should == 2
    end

=begin    
    it "should change the current database version to the previous one when rolled back" do
      @post.title = "Version 2"
      @post.save
      @post.title = "Version 3"
      @post.save
      @post.rollback
      @post.title.should == "Version 2"
    end

    it "should know if the database version is the latest" do
      @post.showing_latest_revision?.should == true
      @post.rollback
      @post.showing_latest_revision?.should == false
    end
=end  
    
  end
    
  after(:each) do
    FileUtils.rm_rf('/tmp/.data')
  end
    
end
