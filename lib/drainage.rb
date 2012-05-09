require "./lib/map"

def calculate_drainage(hmap, dmap)
  
  pits = 0 
  for x in 0..hmap.size-1
    for y in 0..hmap[0].size-1
      
      max_down_slope = 0
      max_down_slope_x = x
      max_down_slope_y = y
      
      location = hmap[x][y]
      
      hex_neighbors(hmap, x, y) do |i, j, neighbor|
        
        slope = location - neighbor
        
        if slope > max_down_slope
          max_down_slope = slope
          max_down_slope_x = i
          max_down_slope_y = j
        end
              
      end
      
      if max_down_slope == 0
        pits += 1
      else
        dmap[max_down_slope_x][max_down_slope_y] += dmap[x][y]
      end
      
    end
  end

  puts "Found #{pits} pits."
end


