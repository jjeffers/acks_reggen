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