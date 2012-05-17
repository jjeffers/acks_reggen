def map_each(map, start = 0, stop = 1)
  
  for y in 0..map[0].size-stop
    for x in 0..map.size-stop
      yield x, y, map[x][y]
    end
  end
  
end

def print_map(map)
   
  for y in 0..$height-1 
    print "\n"
    for x in 0..$width-1
      print " " + (map[x][y].nil? ? "---" : "%03d" % map[x][y])
    end
  end
  puts "\n"

end


def neighbors(map, x, y)
  
  if x > 0
    yield x-1, y, map[x-1][y]
  end

  
  if x < (map.size-1)
    yield x+1, y, map[x+1][y]
  end
  
  
  if y > 0
    yield x, y-1, map[x][y-1]
  end
  
  
  if y < (map[0].size - 1)
    yield x, y+1, map[x][y+1]
  end
  
  
  if x > 0 and y < (map[0].size-1)
    yield x-1, y+1, map[x-1][y+1]
  end
  
  
  if x < (map.size-1) and y > 0
    yield x+1, y-1, map[x+1][y-1]
  end
  
  if x < (map.size-1) and y < (map[0].size-1)
    yield x+1, y+1, map[x+1][y+1]
  end
  
  if x > 0 and y > 0
    yield x-1, y-1, map[x-1][y-1]
  end
  
end


def hex_neighbors(map, x, y)
  
  if y > 0
    yield x, y-1, map[x][y-1]
  end
  
  if y < (map[0].size - 1)
    yield x, y+1, map[x][y+1]
  end

  if x % 2 != 0
    
    if x > 0
      yield x-1, y, map[x-1][y]
    end
  
    if x < (map.size-1)
      yield x+1, y, map[x+1][y]
    end
    
    if x > 0 and y > 0
      yield x-1, y-1, map[x-1][y-1]
    end
    
    if x < (map.size-1) and y > 0
      yield x+1, y-1, map[x+1][y-1]
    end
    
  else # EVEN x index (shifted down 1/2 hex for that column)
    
    if x > 0
      yield x-1, y, map[x-1][y]
    end
    
    if x < (map.size-1)
      yield x+1, y, map[x+1][y]
    end
    
    if x > 0  and y < (map[0].size-1)
      yield x-1, y+1, map[x-1][y+1]
    end
    
    if x < (map.size-1) and y < (map[0].size-1)
      yield x+1, y+1, map[x+1][y+1]
    end
    
  end
  
  
  
  
end