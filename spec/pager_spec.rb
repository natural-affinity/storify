require 'spec_helper'

describe Storify::Pager do
  context "Page" do
    it "should optionally accept a starting page" do
      Storify::Pager.new(page: 10).page.should == 10
    end

    it "should set the default starting page to 1" do
      Storify::Pager.new.page.should == 1
    end

    it "should limit the page to the API Min" do
      pager = Storify::Pager.new(page: -1)
      pager.page.should == Storify::Pager::MIN_PAGE
    end

    it "should optionally allow an artificial max page (inclusive)" do
      pager = Storify::Pager.new(max: 20)
      pager.max.should == 20
    end

    it "should default the page max to unlimited (0)" do
      pager = Storify::Pager.new
      pager.max.should == 0
    end

    it "should allow a page to be advanced (forward)" do
      pager = Storify::Pager.new
      pager.next.page.should == 2
    end

    it "should not allow a page to be advanced beyond (max + 1)" do
      pager = Storify::Pager.new(max: 2)
      pager.next.next.next.page.should == 3
    end

    it "should allow a page to be advanced (backward)" do
      pager = Storify::Pager.new(page: 2)
      pager.prev.prev.page.should == 1
    end
  end

  context "Per Page" do
    it "should optionally accept a per page option" do
      Storify::Pager.new(per_page: 15).per_page.should == 15
    end

    it "should set the default per_page to 20" do
      Storify::Pager.new.per_page.should == 20
    end

    it "should limit per_page to the API Max" do
      # Constructor
      pager = Storify::Pager.new(per_page: 100)
      pager.per_page.should == Storify::Pager::MAX_PER_PAGE

      # Setter
      pager.per_page = 500
      pager.per_page.should == Storify::Pager::MAX_PER_PAGE
    end
  end

  context "Utility" do
    it "should provide access to pagnination as a parameter hash" do
      pager = Storify::Pager.new(page: 13, per_page: 25).to_hash
      pager[:page].should == 13
      pager[:per_page].should == 25
    end

    it "should know if there are pages left based on content array size" do
      data = {'content' => {'stories' => ['s1', 's2', 's3']}}
      pager = Storify::Pager.new
      pager.has_pages?(data['content']['stories']).should be_true
      pager.has_pages?(data['content'][:invalid]).should be_false
      pager.has_pages?([]).should be_false
    end

    it "should have no pages left once on the final page" do
      pager = Storify::Pager.new(max: 2)
      pager.next.next.next
      pager.has_pages?(['g']).should be_false
    end
  end
end