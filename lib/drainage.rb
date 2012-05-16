require "./lib/map"

def calculate_drainage(hmap, dmap)
  
  pits = 0 
  
  map_each(hmap) do |x, y, cell|

    location = hmap[x][y]

    deepest_neighbor_x, deepest_neighbor_y = find_deepest_neighbor(hmap, x, y)

    if deepest_neighbor_x == x and deepest_neighbor_y == y
      pits += 1
      puts "Found a pit at " + x.to_s + ", " + y.to_s

      dmap[x][y] = x,y

      deepest_pour_point = hmap[x][y]
      find_plateau_neighbors(hmap, x, y).each do |i, j, neighbor|
        puts "\tneighbor at same height at " + i.to_s + "," + j.to_s

        plateau_pour_point_x = i
        plateau_pour_point_y = j

        deepest_plateau_neighbor_x, deepest_plateau_neighbor_y = 
        find_deepest_neighbor(hmap, i, j)

        if deepest_plateau_neighbor_x != i or deepest_plateau_neighbor_y != j
          puts "\t\tFound a plateau pour point."
          if hmap[deepest_plateau_neighbor_x][deepest_plateau_neighbor_y] < deepest_pour_point
            plateau_pour_point_x = deepest_plateau_neighbor_x
            plateau_pour_point_x = deepest_plateau_neighbor_y
            deepest_pour_point = hmap[deepest_plateau_neighbor_x][deepest_plateau_neighbor_y]
          end

        end

        if plateau_pour_point_x != i or plateau_pour_point_y != j
          dmap[x][y] = plateau_pour_point_x,plateau_pour_point_y
        end

      end

    else
      puts "Deepest slope at " + x.to_s + ", " + y.to_s + " is at adj " + 
      deepest_neighbor_x.to_s + ", " + deepest_neighbor_y.to_s
      dmap[x][y] = deepest_neighbor_x, deepest_neighbor_y
    end

  end

  puts "Found #{pits} pits."
end

def calculate_flow_accumulation(dmap, fmap)
  
  pits = 0 
  for x in 0..dmap.size-1
    for y in 0..dmap[0].size-1
      
      puts "\Starting flow from " + x.to_s + ", " + y.to_s 
        
      current_x = x
      current_y = y
      
      next_location = dmap[x][y]
      
      while next_location[0] != current_x or next_location[1] != current_y
        
        puts "\tFollowing flow from " + current_x.to_s + ", " + current_y.to_s +  
          " to neighbor at " + next_location[0].to_s + "," + next_location[1].to_s
          
        
        fmap[current_x][current_y] += 1.0
        
        current_x = next_location[0]
        current_y = next_location[1]
        next_location = dmap[current_x][current_y]
        
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

