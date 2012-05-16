def linear_midpoint_displacement(start, endpoint, length)
  
  max_offset = 1
  roughness = 1.0
  
  values = [0.0, 0.0]
  while values.size < length do
    values = values.enum_for(:each_cons, 2).map do |left, right|
      mid = (left + right) / 2
      r = (rand(4)-2) 
      mid += r * max_offset
      [left, mid.to_i]
    end.flatten << values[-1]
    max_offset *= roughness
  end 

  values
end

def tmd(start, endpoint, radians, length)
  
  max_offset = 1
  roughness = 1.0
  
  values = [start, endpoint]
  while values.size < length do
    values = values.enum_for(:each_cons, 2).map do |left, right|
      puts "left: " + left[0].to_s + ", " + left[1].to_s
      puts "right: " + right[0].to_s + ", " + right[1].to_s
      mid = [(left[0] + right[0]) / 2, (left[1] + right[1]) / 2]
      r = (rand(4)-2) 
      
      p_x = mid[0] + (r * max_offset)
      p_y = mid[1]
      
      px = Math.cos(radians) * (p_x - mid[0]) - Math.sin(radians) * (p_y - mid[1]) + mid[0]
      py = Math.sin(radians) * (p_x - mid[0]) + Math.cos(radians) * (p_y - mid[1]) + mid[1]
      
      
      [left, [px.to_i, py.to_i]]
    end << values[-1]
    max_offset *= roughness
  end 

  values
end