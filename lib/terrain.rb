
def determine_terrain_type(height, drainage, water)

  if height > $mountain_threshold
    
    if water >= 0.5 
      return "forested_mountain"
    else
      return "mountain"
    end
    
  elsif height <= $mountain_threshold and height > $hill_threshold
    
    if water >=  0.5
      return "forested_hill"
    elsif water > 0.0 and water < 0.5 
      return "grassy_hill"
    else 
      return "hill"
    end
    
  elsif height <= $hill_threshold and height > $plain_threshold

    if water >=  2.0
      return "lake"
    elsif water > 1.0 and water < 2.0 and height < ($plain_threshold*1.10)
      return "swamp"
    elsif water >=  0.5 and water < 1.0 
      return "woods"
    elsif water >=  1.0 and water < 2.0
      return "forest"
    elsif water > 0.0 and water < 0.5
      return "grassland"
    else
      return "plain"
    end

  else height <= $plain_threshold
    return "sea"
  end

end


def determine_terrain(hmap, dmap, wmap, tmap)
  
  map_each(hmap) do |x,y,cell|
    tmap[x][y] = determine_terrain_type(hmap[x][y], dmap[x][y], wmap[x][y])
  end
  
end

def find_closest_water(hexmap, x, y)

  closest_source_x = -1
  closest_source_y = -1
  closest_source_distance = 99999

  #puts "Checking water sources near " + x.to_s + "," + y.to_s
  
  for i in 0..$width-1
    for j in 0..$height-1
      
      if hexmap[i][j][:drainage][:source]
        
        distance = Math.sqrt(((x-i).abs**2) + ((y-j).abs**2))
        #puts "water source at " + i.to_s + "," + j.to_s + " dist of " + distance.to_s
        
        if distance < closest_source_distance
          closest_source_distance = distance
          closest_source_x = i
          closest_source_y = j
        end
      end
      
    end
  end
  #puts x.to_s + "," + y.to_s + " dist to water = " + closest_source_distance.to_s
    
  return closest_source_distance
      
end