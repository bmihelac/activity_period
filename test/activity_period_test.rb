require 'test_helper'

class ActivityPeriodTest < ActiveSupport::TestCase

  def setup
    load_schema
  end


  class Article < ActiveRecord::Base
     has_active_period
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Article.all
  end

  def test_is_active?
    article = Article.create(:name => "article 1", 
                             :active_from => Date.new(2010,6,15),
                             :active_to => Date.new(2010,6,20))
    ["2010-06-15", "2010-06-20", "2010-06-17"].each do |date|
      assert article.is_active?(Date.parse(date))
    end
    ["2011-01-01", "2010-01-20", "2010-06-21"].each do |date|
      assert !article.is_active?(Date.parse(date))
    end

    article.active_from = nil
    assert article.is_active?(Date.parse("2010-01-01"))
    assert !article.is_active?(Date.parse("2010-06-21"))
  end

  def test_scope
    article = Article.create(:name => "article 1", 
                             :active_from => Date.new(2010,6,15),
                             :active_to => Date.new(2010,6,20))
    ["2010-06-15", "2010-06-20", "2010-06-17"].each do |date|
      assert Article.active(date).include?(article)
    end
  end

end
