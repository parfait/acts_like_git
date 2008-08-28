require File.join(File.dirname(__FILE__), '..', 'spec_helper')

context "A Post that versions a title field" do

  before(:each) do
    # Grit.debug = true
    @post = Post.create(:title => "Moo", :body => "RAR")
    @repo_dir = File.join('/', '.data', 'git_store')
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
      FileUtils.expects(:mkdir_p).times(0)
      Grit::Repo.expects(:new).times(0)
      p = Post.new
    end
  end

  describe "on update" do
    
    it "should calculate the fields that have changed" do
      @post.title = "Another Moo"
      @post.changed_versioned_fields.should == [:title]      
    end
    
    it "should create a folder structure, and file (containing field contents) for each field for the model instance" do
      stub_all(:except => :create_git_folder_structure)
      FileUtils.expects(:mkdir_p).with(File.join(@repo_dir, 'posts', @post.id.to_s))
      @post.title = "New Title"
      @post.save
    end
    
    it "should create a file with the field changes with the /model/id/field.txt format" do
      file_mock = mock
      file_mock.expects(:puts).with("Moo")
      file_mock.expects(:close)
      stub_all(:except => :write_field_contents_to_file)
      File.expects(:open).with(File.join(@repo_dir, 'posts', @post.id.to_s, 'title.txt'), 'w').returns(file_mock)
      @post.title.should == "Moo"
      @post.title = "This is my new title"
      @post.save
    end
    
    it "should add files created to git" do
      @post.title = "This is another new title"
      @post.save
    end
    
    it "should commit all changes to git" do
      stub_all(:except => :commit_all)
      git_mock = mock
      git_mock.expects(:commit_all).with("new version of Post, id: #{@post.id.to_s}")
      @post.expects(:git).returns(git_mock)
      @post.title = "New Title"
      @post.save
    end
    
    it "should list all available version strings for a file as a log" do
      stub_all
      @post.log.should be_kind_of(Array)
    end
    
    it "should increment version counts when updates occur" do
      @post.title = "New title to increment the commit count"
      @post.save
      @post.versions.should == 1
      @post.title = "Another new title to increment the commit count"
      @post.save
      @post.versions.should == 2
    end
    
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
    
    def stub_all(exception = {})
      Grit.stubs(:sh)
      [ 
        :write_field_contents_to_file,
        :create_git_folder_structure,
        :add_file_to_git,
        :commit_all,
        :init_git_directory
      ].each do |method|
        @post.stubs(method) unless exception[:except] == method
      end
    end
    
    def stub_system_calls
      @post.stubs :system_call
    end
    
  end
    
  after(:each) do
    FileUtils.rm_rf('/.data')
  end
    
end