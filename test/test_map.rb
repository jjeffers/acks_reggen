require "map"
require "test/unit"
 
class TestMap < Test::Unit::TestCase
 
  def setup
    
    @map = Array.new(5) { Array.new(5) }

    @neighbors = []

  end
  
  def test_ul_corner
    neighbors(@map, 0, 0) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert_equal(3, @neighbors.size)
    assert(@neighbors.include?([1,0]))
    assert(@neighbors.include?([0,1]))
    assert(@neighbors.include?([1,1]))
    
  end
  
  def test_ur_corner
    
    neighbors(@map, 4, 0) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert_equal(3, @neighbors.size)
    assert(@neighbors.include?([3,0]))
    assert(@neighbors.include?([3,1]))
    assert(@neighbors.include?([4,1]))
    
  end
  
  def test_lr_corner
    
    neighbors(@map, 4, 4) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([4,3]))
    assert(@neighbors.include?([3,4]))
    assert(@neighbors.include?([3,3]))
    
  end
  
  def test_ll_corner
    
    neighbors(@map, 0, 4) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([0,3]))
    assert(@neighbors.include?([1,3]))
    assert(@neighbors.include?([1,4]))
    
  end
  
  def test_non_corner
    
    neighbors(@map, 2, 3) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([1,2]))
    assert(@neighbors.include?([2,2]))
    assert(@neighbors.include?([3,2]))
    assert(@neighbors.include?([2,2]))
    assert(@neighbors.include?([2,4]))
    assert(@neighbors.include?([1,4]))
    assert(@neighbors.include?([2,4]))
    assert(@neighbors.include?([3,4]))
    
  end
  
end