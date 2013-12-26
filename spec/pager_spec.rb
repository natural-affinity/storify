require 'spec_helper'

describe Storify::Pager do
  context ".page" do
    it "optionally accepts a starting page" do
      expect(Storify::Pager.new(page: 10).page).to eql 10
    end

    it "sets the default starting page to 1" do
      expect(Storify::Pager.new.page).to eql 1
    end

    it "limits the page to the API minimum" do
      expect(Storify::Pager.new(page: -1).page).to eql Storify::Pager::MIN_PAGE
    end

    it "optionally allows an artificial max page (inclusive)" do
      expect(Storify::Pager.new(max: 20).max).to eql 20
    end

    it "sets the default the page max to unlimited" do
      expect(Storify::Pager.new.max).to eql 0
    end

    it "allows a page to be advanced forward" do
      expect(Storify::Pager.new.next.page).to eql 2
    end

    it "does not allow a page to be advanced beyond max + 1" do
      expect(Storify::Pager.new(max: 2).next.next.next.page).to eql 3
    end

    it "allows a page to be advanced backward" do
      expect(Storify::Pager.new(page: 2).prev.prev.page).to eql 1
    end
  end

  context ".per_page" do
    it "optionally accepts a per page option" do
      expect(Storify::Pager.new(per_page: 15).per_page).to eql 15
    end

    it "sets the default per_page to 20" do
      expect(Storify::Pager.new.per_page).to eql 20
    end

    it "limits per_page to the API maximum (constructor)" do
      expect(Storify::Pager.new(per_page: 100).per_page).to eql Storify::Pager::MAX_PER_PAGE
    end

    it "limits per_page to the API maximum (setter)" do
      pager = Storify::Pager.new
      pager.per_page = 500
      expect(pager.per_page).to eql Storify::Pager::MAX_PER_PAGE
    end
  end

  context ".to_hash" do
    it "hashifies pagination parameters" do
      pager = Storify::Pager.new(page: 13, per_page: 25).to_hash
      expect(pager[:page]).to eql 13
      expect(pager[:per_page]).to eql 25
    end
  end

  context ".has_pages?" do
    it "knows if there are pages left based on content array size" do
      data = {'content' => {'stories' => ['s1', 's2', 's3']}}
      pager = Storify::Pager.new

      expect(pager.has_pages?(data['content']['stories'])).to be_true
      expect(pager.has_pages?(data['content'][:invalid])).to be_false
      expect(pager.has_pages?([])).to be_false
    end

    it "has no pages left once on the final page" do
      expect(Storify::Pager.new(max: 2).next.next.next.has_pages?(['g'])).to be_false
    end
  end
end