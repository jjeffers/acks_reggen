require "map"
require "test/unit"
 
class TestMap < Test::Unit::TestCase
 
  def setup
    
    @map = Array.new(5) { Array.new(5) }

    @neighbors = []

  end
  
  def test_ul_corner
    hex_neighbors(@map, 0, 0) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([1,0]))
    assert(@neighbors.include?([0,1]))
    assert(@neighbors.include?([1,1]))
    assert_equal(3, @neighbors.size)
    
  end
  
  def test_ll_corner
    hex_neighbors(@map, 0, 4) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([0,3]))
    assert(@neighbors.include?([1,4]))
    assert_equal(2, @neighbors.size)
    
  end
  
  def test_ur_corner_even_index
    hex_neighbors(@map, 4, 0) do |x, y, location|
      @neighbors << [x, y]
    end
    
    assert(@neighbors.include?([3,0]))
    assert(@neighbors.include?([3,1]))
    assert(@neighbors.include?([4,1]))
    assert_equal(3, @neighbors.size)
    
  end
  
  def test_lr_corner_even_index
     hex_neighbors(@map, 4, 4) do |x, y, location|
       @neighbors << [x, y]
     end

     assert(@neighbors.include?([3,4]))
     assert(@neighbors.include?([4,3]))
     assert_equal(2, @neighbors.size)

   end
 
   def test_ur_corner_odd_index
     @map = @map = Array.new(4) { Array.new(4) }
     
     hex_neighbors(@map, 3, 0) do |x, y, location|
       @neighbors << [x, y]
     end

     assert(@neighbors.include?([2,0]))
     assert(@neighbors.include?([3,1]))
     assert_equal(2, @neighbors.size)

   end
   
   def test_lr_corner_odd_index
      @map = @map = Array.new(4) { Array.new(4) }

      hex_neighbors(@map, 3, 3) do |x, y, location|
        @neighbors << [x, y]
      end

      assert(@neighbors.include?([3,2]))
      assert(@neighbors.include?([2,2]))
      assert(@neighbors.include?([2,3]))
      assert_equal(3, @neighbors.size)

    end
    
  def test_non_corner_odd_index
    
    hex_neighbors(@map, 1, 1) do |x, y, location|
      @neighbors << [x, y]
    end
    

    assert(@neighbors.include?([1,0]))
    assert(@neighbors.include?([1,2]))
    assert(@neighbors.include?([0,0]))
    assert(@neighbors.include?([0,1]))
    assert(@neighbors.include?([2,0]))
    assert(@neighbors.include?([2,1]))
    assert_equal(6, @neighbors.size)
        
  end
  
  def test_non_corner_odd_index
    
    hex_neighbors(@map, 2, 2) do |x, y, location|
      @neighbors << [x, y]
    end
    

    assert(@neighbors.include?([2,1]))
    assert(@neighbors.include?([2,3]))
    assert(@neighbors.include?([1,2]))
    assert(@neighbors.include?([1,3]))
    assert(@neighbors.include?([3,2]))
    assert(@neighbors.include?([3,3]))
    assert_equal(6, @neighbors.size)
        
  end
  
end