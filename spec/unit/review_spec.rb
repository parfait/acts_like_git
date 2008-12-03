require File.dirname(__FILE__) + '/../spec_helper'

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

  it "should have history for content" do
    @review.history(:content).should_not be_empty
  end

  it "should have history for user_id" do
    @review.history(:user_id).should_not be_empty
  end
end
