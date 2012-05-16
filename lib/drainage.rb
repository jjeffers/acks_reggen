require "./lib/map"

def calculate_drainage(hmap, dmap)
  
  pits = 0 
  for x in 0..hmap.size-1
    for y in 0..hmap[0].size-1
      
      location = hmap[x][y]
      
      deepest_neighbor_x, deepest_neighbor_y = find_deepest_neighbor(hmap, x, y)
      
      if deepest_neighbor_x == x and deepest_neighbor_y == y
        pits += 1
        puts "Found a pit at " + x.to_s + ", " + y.to_s
        
        
        find_plateau_neighbors(hmap, x, y).each do |i, j, neighbor|
          puts "\tneighbor at same height at " + i.to_s + "," + j.to_s
          
          deepest_plateau_neighbor_x, deepest_plateau_neighbor_y = 
            find_deepest_neighbor(hmap, i, j)
            
          if deepest_plateau_neighbor_x != i and deepest_plateau_neighbor_y != j
            puts "\t\tFound a plateau pour point."
          end
          
        end
        
        dmap[x][y] = x,y
      else
        puts "Deepest slope at " + x.to_s + ", " + y.to_s + " is at adj " + 
          deepest_neighbor_x.to_s + ", " + deepest_neighbor_y.to_s
        dmap[x][y] = deepest_neighbor_x, deepest_neighbor_y
      end
      
    end
  end

  puts "Found #{pits} pits."
end

def calculate_flow_accumulation(dmap, fmap)
  
  pits = 0 
  for x in 0..dmap.size-1
    for y in 0..dmap[0].size-1
      
      location = dmap[x][y]
      if location[0] != x or location[1] != y
        puts "Adding flow from " + x.to_s + ", " + y.to_s +  
          " to neighbor at " + location[0].to_s + "," + location[1].to_s
        fmap[location[0]][location[1]] += 
          fmap[x][y]
      end
      
    end
  end

end

def find_deepest_neighbor(hmap, x, y)

  deepest_x = x
  deepest_y = y
  
  steepest_slope = 0
  location = hmap[x][y]
  hex_neighbors(hmap, x, y) do |i, j, neighbor|
    
    slope = location - neighbor
    if slope > steepest_slope
      steepest_slope = slope
      deepest_x = i
      deepest_y = j
    end

  end

  return deepest_x, deepest_y

end

def find_plateau_neighbors(hmap, x, y)

  
  list = []

  location = hmap[x][y]

  hex_neighbors(hmap, x, y) do |i, j, neighbor|
    if neighbor.to_i == location.to_i 
      list << [i, j, neighbor]
    end
  end

  list

end


def determine_rivers(fmap, dmap, rmap, threshold)

  map_each(fmap) do |x, y, accumulated_flow|

    if accumulated_flow < threshold
      next
    end

    puts "Setting river flow from " + x.to_s + ", " + y.to_s +  
    " to neighbor at " + dmap[x][y][0].to_s + "," + dmap[x][y][1].to_s

    rmap[x][y] = dmap[x][y]

  end


end

