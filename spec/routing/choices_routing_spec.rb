require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChoicesController do
  before(:all) do 

    @aoi_clone = Factory.create(:user)
    @valid_attributes = {
      :site => @aoi_clone,
      :creator => @aoi_clone.default_visitor
      
    }
    @q = Question.create!(@valid_attributes)
  end
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "choices", :action => "index", :question_id => @q.id.to_s).should == "/questions/#{@q.id}/choices"
    end

    it "maps #show" do
      route_for(:controller => "choices", :action => "show", :id => "1", :question_id => @q.id.to_s).should == "/questions/#{@q.id}/choices/1"
    end

    it "maps #create" do
      route_for(:controller => "choices", :action => "create", :question_id => @q.id.to_s).should == {:path => "/questions/#{@q.id}/choices", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "choices", :action => "update", :id => "1", :question_id => @q.id.to_s).should == {:path =>"/questions/#{@q.id}/choices/1", :method => :put}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/questions/#{@q.id.to_s}/choices").should == {:controller => "choices", :action => "index", :question_id => @q.id.to_s}
    end

    it "generates params for #create" do
      params_from(:post, "/questions/#{@q.id}/choices").should == {:controller => "choices", :action => "create", :question_id => @q.id.to_s}
    end

    it "generates params for #show" do
      params_from(:get, "/questions/#{@q.id}/choices/1").should == {:controller => "choices", :action => "show", :id => "1", :question_id => @q.id.to_s}
    end

    it "generates params for #update" do
      params_from(:put, "/questions/#{@q.id}/choices/1").should == {:controller => "choices", :action => "update", :id => "1", :question_id => @q.id.to_s}
    end
  end
end
