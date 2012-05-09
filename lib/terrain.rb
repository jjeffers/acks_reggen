
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

    puts water
    puts height
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