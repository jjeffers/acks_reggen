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
