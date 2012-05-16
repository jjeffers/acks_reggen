require "drainage"
require "test/unit"
 
class TestDrainage < Test::Unit::TestCase
 
  def setup
    
    @map = Array.new(5) { Array.new(5) }
    @dmap = Array.new(5) { Array.new(5) { 1.0 } }
    
    for x in 0..@map.size-1
      for y in 0..@map[0].size-1
        @map[x][y] = x > y ? x : y 
      end
    end
    
    calculate_drainage(@map, @dmap)
  end

 
  def test_deepest_neighbor
    
    # 145 149 133
    # 137 145 134
    # 131 140 132
     
    @hmap = Array.new(3) { Array.new(3) }
    @hmap[0][0] = 145
    @hmap[1][0] = 149
    @hmap[2][0] = 133
    @hmap[0][1] = 137
    @hmap[1][1] = 145
    @hmap[2][1] = 134
    @hmap[0][2] = 131
    @hmap[1][2] = 140
    @hmap[2][2] = 132
    
    x, y = find_deepest_neighbor(@hmap, 2, 1)
    
    assert_equal(2, x)
    assert_equal(2, y)
  end
end