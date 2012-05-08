require "map"
require "erosion"
require "test/unit"
 
class TestErosion < Test::Unit::TestCase
 
  def setup
    
    @height_map = Array.new(5) { Array.new(5, 100.0) }
    @water_map = Array.new(5) { Array.new(5, 0.0) }
    @sediment_map = Array.new(5) { Array.new(5, 0.0) }
    @rain_constant = 0.01
    @solubility_constant = 0.01
  end
  
  def test_rain
    
    Erosion::add_rain(@water_map, @rain_constant)
    
    @water_map.each do |row|
      row.each do |cell|
        assert_equal(@rain_constant, cell)
      end
    end
    
  end
  
  def test_sediment_removal
    
    @water_map = Array.new(5) { Array.new(5, 100.0) }
    Erosion::erode_soil(@height_map, @water_map, @sediment_map, @solubility_constant)
    
    @height_map.each do |row|
      row.each do |cell|
        assert_equal(99.0, cell)
      end
    end
    
    @sediment_map.each do |row|
      row.each do |cell|
        assert_equal(1.0, cell)
      end
    end
    
  end
  
  def test_water_dispersion
    
    @height_map = Array.new(3) { Array.new(3, 80.0) }
    @height_map[1][1] = 100.0
    
    @water_map = Array.new(3) { Array.new(3, 10.0) }
    @sediment_map = Array.new(5) { Array.new(5, 0.1) }
    
    Erosion::disperse_water(@height_map, @water_map, @sediment_map)
    
  end
  
  def test_water_evaporation
    
    @height_map = Array.new(3) { Array.new(3, 80.0) }
    @height_map[1][1] = 100.0
    
    @water_map = Array.new(3) { Array.new(3, 10.0) }
    @water_map[1][1] = 90.0
     
    @sediment_map = Array.new(3) { Array.new(3, 0.1) }
    @sediment_map[1][1] = 0.05
    
    @evaporation_rate = 0.5
    @sediment_capacity = 0.01
    
    Erosion::evaporate_water(@height_map, @water_map, @sediment_map, 
      @evaporation_rate, @sediment_capacity)

      @height_map.each do |row|
        row.each do |cell|
          puts cell
        end
      end
  end
  
  def test_water_evaporation
    
    @height_map = Array.new(30) { Array.new(30) { 80+rand(10)} }
    @height_map[15][15] = 100.0
    
    @water_map = Array.new(30) { Array.new(30, 0.0) }
    @sediment_map = Array.new(30) { Array.new(30, 0.0) }

     puts "\n"
        @height_map.each do |row|
          row.each do |cell|
            print " " + "%02d" % cell
          end
          print "\n"
        end
        
    10.times  { Erosion::erode(@height_map, @water_map, @sediment_map) }
    puts "\n"
      @height_map.each do |row|
        row.each do |cell|
          print " " + "%02d" % cell
        end
        print "\n"
      end
  end
  
  
  
end