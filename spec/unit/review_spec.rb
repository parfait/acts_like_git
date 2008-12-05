require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "it keeps history" do
  it "should have history for content" do
    @review.history(:content).should_not be_empty
  end

  it "should have history for user_id" do
    @review.history(:user_id).should_not be_empty
  end
end

context "A Review that versions a integer field along with a string" do
  before(:each) do
    @review = Review.create!(:content => "Stuff", :user_id => 1)
  end

  it "should version content" do
    @review.git_settings.versioned_fields.should include(:content) 
  end

  it "should version user_id" do
    @review.git_settings.versioned_fields.should include(:user_id) 
  end

  it_should_behave_like "it keeps history"

	it "should allow for modifications and versioning" do
		@review.user_id = 13
		@review.content = "More Stuff"
		@review.save

		@review.log.size.should == 2
		@review.history(:content).size.should == 2
		@review.history(:user_id).size.should == 2
	end
end

#TODO: Get this working as well.
#context "A Review with associated User model gets versioned" do
#  before(:each) do
#    @user = User.create!(:name => "Nick")
#    @review = Review.create!(:content => "Stuff", :user => @user)
#  end
#
#  it_should_behave_like "it keeps history"
#end
