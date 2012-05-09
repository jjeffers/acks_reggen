require "prawn"
require "active_support/inflector"
require "./lib/plasma_fractal"
require "./lib/drainage"
require "./lib/erosion"
require "./lib/terrain"

$number_of_locations = 45

sin60 = 0.866025404
$C = 10
$A = 0.5*$C
$B = $C*sin60

$hex_bases = [ [0, $B], [$A, 0], [$A+$C, 0], [2*$C, $B], [$A+$C, 2*$B], [$A, 2*$B]]

$width = 30
$height = 40
$max_height = $height*(2*$B)
$hbias = 0.0 
$vbias = 0.0
$total_bias = ($hbias.abs.to_f+$vbias.abs.to_f)/2.0


def generate_ruin_or_lair(lmap, x,y)

  roll = rand(30)

  type = ""
  case roll 
  when 0..3 
    type = "megadungeon"
  when 3..13
    type = "dungeon"
  else
    type = "lair"
  end

  lmap[x][y] = type
end

def generate_hex(lmap, tmap, x, y)

  if tmap[x][y] == "sea"
    return
  end
  
  number_of_locations = 45.0/1200.0 * ($width * $height)
  
  if rand($width*$height) <= number_of_locations

    roll = rand(100)
    vbias = ((y.to_f/$height.to_f*$vbias) + (-1*($vbias/2.0)))
    hbias = ((x.to_f/$width.to_f*$hbias)+ (-1*($hbias/2.0)))

    if $total_bias == 0
      bias = 0
    else
      bias = (vbias.abs.to_f/$total_bias)*vbias.to_f + (hbias.abs.to_f/$total_bias)*hbias.to_f
    end
    
    roll += bias
    
    if (roll <= 33)
      lmap[x][y] = "settlement"      
    else
      generate_ruin_or_lair(lmap, x, y)
    end
 
  end
end

def draw_hex(pdf, location, terrain, drainage, x, y)

  if x % 2 == 0
    x_offset = x * ($A+$C)
    y_offset = y * (2*$B)
  else
    x_offset = x * ($A+$C)
    y_offset = (y * (2*$B)) - $B
  end
  y_offset = $max_height - y_offset
  
  coords = $hex_bases.map { | coordinate| [coordinate[0]+x_offset, coordinate[1]+y_offset] }
  pdf.stroke_polygon *coords
  
                  
  if terrain != nil
    
    x_pos = x_offset+$C
    y_pos = y_offset+$B
    if terrain == "mountain"
      pdf.image "#{settings.root}/images/mountains.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "forested_mountain"
      pdf.image "#{settings.root}/images/forestedmountains.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "hill"
      pdf.image "#{settings.root}/images/hills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "forested_hill"
      pdf.image "#{settings.root}/images/forestedhills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "grassy_hill"
      pdf.image "#{settings.root}/images/grassyhills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "forest"
      pdf.image "#{settings.root}/images/heavyforest.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "grassland"
      #pdf.image "#{settings.root}/images/grassland.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "woods"
      pdf.image "#{settings.root}/images/lightforest.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "swamp"
      pdf.image "#{settings.root}/images/marsh.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "plain"
      #pdf.image "#{settings.root}/images/hills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif terrain == "sea" or terrain == "lake"
      pdf.fill_color "0000ff"
      pdf.fill_polygon *coords
      pdf.fill_color "000000"
    end
   
    if location == "dungeon"
      pdf.image "#{settings.root}/images/dungeon.png", :at => [x_pos-6, y_pos+6], :fit => [$B+$A/2,$B+$A/2]
    elsif location  == "megadungeon"
      pdf.image "#{settings.root}/images/dungeon.png", :at => [x_pos-5, y_pos+8], :fit => [$B+$A,$B+$A]
    elsif location  == "lair"
      pdf.image "#{settings.root}/images/cave.png", :at => [x_pos-4, y_pos+5], :fit => [$B,$B] 
    elsif location  == "settlement"
      pdf.stroke_rectangle [x_pos-2.5, y_pos+2.5], 5, 5
    end
    
    #water_size = (drainage.to_f / 500.0) * $C
    #if water_size > $C
    #  water_size = $C
    #end
    
    #pdf.fill_color "0000ff"
    #pdf.fill_ellipse [x_pos, y_pos], water_size
    #pdf.fill_color "000000"
    
    #pdf.draw_text location[:height].to_i, :at => [x_pos, y_pos], :size => 6
                    
  end
  
  pdf.font_size(4)
  pdf.draw_text "%02d" % x + "%02d" % y,
             :at => [x_offset+$C-4, y_offset+$B-7]
  
  
end

def generate_pdf(pdf, lmap, tmap, dmap)
  
  map_each(lmap) do |x, y, cell|
    draw_hex(pdf, lmap[x][y], tmap[x][y], dmap[x][y], x, y)
  end
  
  pdf.start_new_page
  pdf.move_down 10
  pdf.font_size(12)
  pdf.text "Region Key"

  location_map = {}
  
  pdf.column_box([0, pdf.cursor],:columns => 2, :width => 500) do
      for x in 0..$width-1
        for y in 0..$height-1
          if lmap[x][y] != ""

            pdf.text  "Hex " + ("%02d" % x + "%02d" % y) +" - a " + lmap[x][y]

            location_map.merge!({ lmap[x][y] => 1 }) { |key, old_count, new_count| old_count + new_count }
          end
        end
      end
      
      pdf.move_down 10
      pdf.text "Summary"
      location_map.each_pair do |k,v|
        pdf.text v.to_s + " " + k.pluralize
      end
      
  end

  puts "Done generating pdf."
  pdf

end

def determine_heightmap(hmap)
  
  pfsize = 1
  
  while (2**pfsize + 1) < $height or (2**pfsize + 1) < $width
    puts "plasma fractal size is " + pfsize.to_s
    pfsize += 1
  end
  
  puts "plasma fractal size is " + pfsize.to_s + " => " + ((2**pfsize)+1).to_s
  fractal = PlasmaFractal.new(:size =>(2**pfsize)+1, :height_seed => 100)
  fractal.generate!
  
  map_each(hmap) do |x,y,cell|
    hmap[x][y] = fractal.data[x][y]
  end
  
  $mountain_threshold = 0.90 * fractal.max.to_f
  $hill_threshold = 0.85 * fractal.max.to_f
  $plain_threshold = 0.60 * fractal.max.to_f
  $max_terrain_height = fractal.max.to_f
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



def generate_map_pdf(pdf, width, height, axis, strength)
  
  $width = width
  $height = height
  puts "Request width " + width.to_s + " and height " + height.to_s

  if axis == "none"
    
  elsif axis == "north"
    $vbias = strength
    $hbias = 0.0
  elsif axis == "northeast"
    $hbias = -1 * strength/2.0
    $vbias = strength/2.0
  elsif axis == "east"
    $hbias = -1 * strength
    $vbias = 0
  elsif axis == "southeast"
    $hbias = -1 * strength/2.0
    $vbias = -1 * strength/2.0
  elsif axis == "south"
    $hbias = 0.0
    $vbias = -1 * strength
  elsif axis == "southwest"
    $hbias = strength/2.0
    $vbias = -1 * strength/2.0
  elsif axis == "west"
    $hbias = strength
    $vbias = 0.0
  elsif axis == "northwest"
    $hbias = strength/2.0
    $vbias = strength/2.0
  end
  
  puts "hbias = " + $hbias.to_s
  puts "vbias = " + $vbias.to_s
  $total_bias = ($hbias.abs.to_f+$vbias.abs.to_f)/2.0
    
  
  lmap = Array.new($width) { Array.new($height) { "" } }
  
  hmap = Array.new($width) { Array.new($height) { 0.0 }}
  dmap = Array.new($width) { Array.new($height) { 1.0 }}
  wmap = Array.new($width) { Array.new($height) { 0.0 }}
  smap = Array.new($width) { Array.new($height) { 0.0 }}
  fmap = Array.new($width) { Array.new($height) { 0.0 }}
  tmap = Array.new($width) { Array.new($height) { "plain" }}
  
  determine_heightmap(hmap)
  
  puts "Eroding 100 times..."
  100.times { Erosion::erode(hmap, wmap, smap) }
  
  puts "height map"
  print_map(hmap)  
  
  3.times { calculate_drainage(hmap, dmap) }
  puts "drainage map"
  print_map(dmap)
  puts "\n"
  
  puts "water map"
  print_map(wmap)
  puts "\n"
   
  determine_terrain(hmap, dmap, wmap, tmap)
 
  display_map_terrain(tmap)
    
  map_each(hmap) do |x, y, cell|
    generate_hex(lmap, tmap, x, y)
  end
  
  return generate_pdf(pdf, lmap, tmap, dmap)
  
end

def display_map_terrain(tmap)
  
  for y in 0..$height-1 
    print "\n"
    for x in 0..$width-1
      v = tmap[x][y]
      if v == "mountain"
        print " M "
      elsif v == "forested_mountain"
        print " F "
      elsif v == "forested_hill"
        print " m "
      elsif v == "grassy_hill"
        print " m "
      elsif v == "hill"
        print " m "
      elsif v == "forest"
        print " f "
      elsif v == "plain"
        print " _ "
      elsif v == "sea"
        print " s "
      else
        print " - "
      end
    end
  end

end


