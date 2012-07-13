require File.dirname(__FILE__) + '/../test_helper'

class RegionTest < Test::Unit::TestCase
  fixtures :ministry_regionalteam

  def test_region_find
    all = Region.find(:all)
    assert all.size > 0
    glid = Region.find(:first, :conditions => ["region = ?", "GL"]).teamID
    assert_equal(5, glid)
  end
  
  def test_standard_regions
    regions = Region.standard_regions
    assert regions.size > 0
  end
end
