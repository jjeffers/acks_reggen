require "drainage"
require "test/unit"
 
class TestDrainage < Test::Unit::TestCase
 
  def setup
    
    @map = Array.new(5) { Array.new(5) }

    for x in 0..@map.size-1
      for y in 0..@map[0].size-1
        @map[x][y] = { :height => x > y ? x : y }
      end
    end
    
    calculate_drainage(@map)
  end
  
  def test_slope_calculation
    assert_equal(1, @map[2][2][:drainage][:slope] )
    assert_equal(0, @map[0][0][:drainage][:slope] )
  end
  
  def test_slope_calculation
    assert_equal(160, @map[0][0][:drainage][:value] )
  end
  
 
end