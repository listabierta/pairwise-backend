require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Choices" do
  include IntegrationSupport

  describe "POST 'create'" do
    before(:each) do
      @question = Factory.create(:aoi_question, :site => @api_user)
      @visitor = Factory.create(:visitor, :site => @api_user)
    end

    describe "succeeds and returns a new choice" do

      specify "given no optional arguments"# do @params = nil end

      specify "given only data" do
        @params = { :choice => { :data => "hey"} }
      end

      after do
        post_auth question_choices_path(@question), @params
        response.should be_success
        response.should have_tag "choice"
      end
    end

    it "correctly sets the supplied attributes" do
      @params = { 
        :choice => {
          :visitor_identifier => @visitor.identifier,
          :data => "foo",
          :local_identifier => "bar" } }

      post_auth question_choices_path(@question), @params

      response.should be_success
      response.should have_tag "choice creator-id", @visitor.id.to_s
      response.should have_tag "choice data", "foo"
      response.should have_tag "choice local-identifier", "bar"
    end
  end

  describe "PUT 'flag'" do
    before do
      @question = Factory.create(:aoi_question, :site => @api_user)
      @choice = Factory.create(:choice, :question => @question)
      @choice.activate!
    end

    it "should return the deactivated choice given no arguments" do 
      put_auth flag_question_choice_path(@question, @choice)

      response.should be_success
      response.should have_tag "choice active", "false"
    end

    it "should return the deactivated choice given an explanation" do 
      put_auth flag_question_choice_path(@question, @choice), :explanation => "foo"

      response.should be_success
      response.should have_tag "choice active", "false"
    end

    it "should fail when trying to flag another site's choices" do
      other_user = Factory(:email_confirmed_user)
      put_auth other_user, flag_question_choice_path(@question, @choice), :explanation => "foo"
      response.should_not be_success
    end
  end

  describe "GET 'index'" do
    before(:each) do
      @question = Factory.create(:aoi_question, :site => @api_user, :choices => [], :prompts => [])
      5.times{ Factory.create(:choice, :question => @question).deactivate! }
      5.times{ Factory.create(:choice, :question => @question).activate! }
    end

    it "should return all active choices given no optional parameters" do
      get_auth question_choices_path(@question)
      
      response.should be_success
      response.should have_tag "choices choice", 5
    end

    it "should return all choices if include_inactive is set" do
      get_auth question_choices_path(@question), :include_inactive => true
      
      response.should be_success
      response.should have_tag "choices choice", 10
      response.should have_tag "choices choice active", "false"
    end


    it "should return 3 choices when limt is set to 3" do
      get_auth question_choices_path(@question), :limit => 3

      response.should be_success
      response.should have_tag "choices choice", 3
    end

    it "should return the remaining choices when offset is provided" do
      get_auth question_choices_path(@question), :offset => 2, :limit => 4

      response.should be_success
      response.should have_tag "choices choice", 3
    end

    it "should fail when trying to access another site's choices" do
      other_user = Factory(:email_confirmed_user)
      get_auth other_user, question_choices_path(@question), :offset => 2, :limit => 4
      response.should_not be_success
    end

  end
  
  describe "GET 'show'" do
    before do
      @question = Factory.create(:aoi_question, :site => @api_user)
      @choice = Factory.create(:choice, :question => @question)
    end

    it "should return a choice" do
      get_auth question_choice_path(@question, @choice)

      response.should be_success
      response.should have_tag "choice", 1
    end

    it "should fail when requesting a choice from another site" do
      other_user = Factory(:email_confirmed_user)
      get_auth other_user, question_choice_path(@question, @choice)
      response.should_not be_success
    end
    
  end

  describe "PUT 'update'" do
    before do
      @question = Factory.create(:aoi_question, :site => @api_user)
      @choice = Factory.create(:choice, :question => @question)
      @choice.activate!
    end

    it "should succeed given valid attributes" do
      params = { :choice => { :data => "foo" } }
      put_auth question_choice_path(@question, @choice), params
      response.should be_success
    end

    it "should fail when updating another site's choice" do
      other_user = Factory(:email_confirmed_user)
      params = { :choice => { :data => "foo" } }
      put_auth other_user, question_choice_path(@question, @choice), params
      response.should_not be_success
    end
  end

end
