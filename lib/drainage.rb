require "./lib/map"

def calculate_drainage(map)
  
  2.times { calculate_slopes(map) }
  
  4.times { |i| calculate_drainage_values(map) }
  
end

def calculate_drainage_values(map)
  
  drainage_threshold = map.size*map[0].size * 50.0/1200.0
  
  for x in 0..map.size-1
    for y in 0..map[0].size-1
  
      location = map[x][y]

      dx = location[:drainage][:x]
      dy = location[:drainage][:y]
      
      
      down_slope_neighbor = map[dx][dy]
      down_slope_neighbor[:drainage][:value] += location[:drainage][:value]
      
      if location[:drainage][:value] >= drainage_threshold
        location[:drainage][:source] = true
      else
        location[:drainage][:source] = false
      end
      
      #puts "drainage at " + x.to_s + ", " + y.to_s + " " + map[x][y][:drainage][:value].to_s
    end
  end
      
end


def calculate_slopes(map)

  pits = 0

  for x in 0..map.size-1
    for y in 0..map[0].size-1
      
      max_down_slope = 0
      max_down_slope_x = x
      max_down_slope_y = y
      
      location = map[x][y]
      lowest_neighbor_x = x
      lowest_neighbor_y = y
      lowest_neighbor_height = 99999
      
      hex_neighbors(map, x, y) do |i, j, neighbor|
        
        slope = location[:height] - neighbor[:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = i
          max_down_slope_y = j
        end
      
        if neighbor[:height] > location[:height]
          if neighbor[:height] < lowest_neighbor_height
            lowest_neighbor_height = neighbor[:height]
          end
        end
        
      end
      
      if max_down_slope == 0
        #puts "pit at: " + location[:height].to_s + " lowest neighbor at: " + lowest_neighbor_height.to_s
        pits += 1
        
        location[:height] = lowest_neighbor_height + 1
        
      end
      
      location[:drainage] = { :x => max_down_slope_x, :y => max_down_slope_y, :slope => max_down_slope, :value => 1 }
      
    end
  end
  
  puts "Found #{pits} pits."
end