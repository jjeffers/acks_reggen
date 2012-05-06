def calculate_drainage(map)
  
  calculate_slopes(map)
  
  3.times { |i| calculate_drainage_values(map) }
  
end

def calculate_drainage_values(map)
  for x in 0..map.size-1
    for y in 0..map[0].size-1
  
      location = map[x][y]

      dx = location[:drainage][:x]
      dy = location[:drainage][:y]
      
      
      down_slope_neighbhor = map[dx][dy]
      down_slope_neighbhor[:drainage][:value] += location[:drainage][:value]
      
    end
  end
      
end


def calculate_slopes(map)

  for x in 0..map.size-1
    for y in 0..map[0].size-1
  
      location = map[x][y]
      
      max_down_slope = 0
      max_down_slope_x = x
      max_down_slope_y = y
      
      if x > 0
        slope = location[:height] - map[x-1][y][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x -1
          max_down_slope_y = y
        end
      
      end
      
      if x < (map.size-1)
        
        slope = location[:height] - map[x+1][y][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x + 1
          max_down_slope_y = y
        end
      
      end
      
      if y > 0
        slope = location[:height] - map[x][y - 1][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x
          max_down_slope_y = y - 1
        end
      
      end
      
      if y < (map[0].size - 1)
        slope = location[:height] - map[x][y+1][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x
          max_down_slope_y = y + 1
        end
      
      end
      
      
      if x > 0 and y > 0
        slope = location[:height] - map[x-1][y-1][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x - 1
          max_down_slope_y = y - 1
        end
      
      end
      
      if x < (map.size-1) and y < (map[0].size-1)
        slope = location[:height] - map[x+1][y+1][:height]
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = x + 1
          max_down_slope_y = y + 1
        end
      
      end
      
      location[:drainage] = { :x => max_down_slope_x, :y => max_down_slope_y, :slope => max_down_slope, :value => 1 }
      
    end
  end
  
end