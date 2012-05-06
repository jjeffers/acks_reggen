require "prawn"
require "active_support/inflector"
require "./lib/plasma_fractal"
require "./lib/drainage"

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


def generate_ruin_or_lair(hexmap, x,y)

  roll = rand(30)

  type = ""
  case roll 
  when 0..3 
    #puts "\t\tmegadungeon (6-10 sessions)"
    type = "megadungeon"
  when 3..13
    #puts "\t\tdungeon (1-2 sessions)"
    type = "dungeon"
  else
    #puts "\t\tsmall lair (1-3 encounters)"
    type = "lair"
  end

  hexmap[x][y] = { :x => x, :y => y, :type => type }
end

def generate_hex(hexmap, x, y)

  number_of_locations = 45.0/1200.0 * ($width * $height)
  
  if rand($width*$height) <= number_of_locations
    #puts "something at " + "%02d" % x + "%02d" % y

    roll = rand(100)
    vbias = ((y.to_f/$height.to_f*$vbias) + (-1*($vbias/2.0)))
    hbias = ((x.to_f/$width.to_f*$hbias)+ (-1*($hbias/2.0)))
    
    #puts "\troll #{roll}"
    if $total_bias == 0
      bias = 0
    else
      bias = (vbias.abs.to_f/$total_bias)*vbias.to_f + (hbias.abs.to_f/$total_bias)*hbias.to_f
    end
    
    #puts "\tbias = #{hbias} #{vbias} #{bias}"
    roll += bias
    #puts "\tadjusted roll #{roll}"
    
    if (roll <= 33)
      #puts "\t\tsettlement"
      hexmap[x][y] = { :x => x, :y => y, :type => "settlement" }
    else
      generate_ruin_or_lair(hexmap, x,y)
    end
      
  else
    hexmap[x][y] = { :x => x, :y => y }
  end
end

def draw_hex(pdf, location, x, y)

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
  
  if location != nil
    
    x_pos = x_offset+$C
    y_pos = y_offset+$B
    if location[:terrain] == "mountain"
      pdf.image "#{settings.root}/images/mountains.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif location[:terrain] == "hill"
      pdf.image "#{settings.root}/images/hills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]  
    elsif location[:terrain] == "plain"
      #pdf.image "#{settings.root}/images/hills.png", :at => [x_pos-7, y_pos+6], :fit => [$A+$B,$A+$B]
    elsif location[:terrain] == "sea"
      pdf.fill_color "0000ff"
      pdf.fill_polygon *coords
      pdf.fill_color "000000"
    end
    
    if location[:type] == "dungeon"
      pdf.image "#{settings.root}/images/dungeon.png", :at => [x_pos-6, y_pos+6], :fit => [$B+$A/2,$B+$A/2]
    elsif location[:type]  == "megadungeon"
      pdf.image "#{settings.root}/images/dungeon.png", :at => [x_pos-5, y_pos+8], :fit => [$B+$A,$B+$A]
    elsif location[:type]  == "lair"
      pdf.image "#{settings.root}/images/cave.png", :at => [x_pos-4, y_pos+5], :fit => [$B,$B] 
    elsif location[:type]  == "settlement"
      pdf.stroke_rectangle [x_pos-2.5, y_pos+2.5], 5, 5
    end
    
    
  end
  
  pdf.font_size(4)
  pdf.draw_text "%02d" % x + "%02d" % y,
             :at => [x_offset+$C-4, y_offset+$B-7]
  
  
end

def generate_pdf(pdf, hexmap)
  
  for x in 0..$width-1
    for y in 0..$height-1
      draw_hex(pdf, hexmap[x][y], x, y)
    end
  end
  
  pdf.start_new_page
  pdf.move_down 10
  pdf.font_size(12)
  pdf.text "Region Key"

  location_map = {}
  
  pdf.column_box([0, pdf.cursor],:columns => 2, :width => 500) do
      for x in 0..$width-1
        for y in 0..$height-1
          if hexmap[x][y][:type]

            pdf.text  "Hex " + ("%02d" % hexmap[x][y][:x] + "%02d" % hexmap[x][y][:y]) + 
              " - a " + hexmap[x][y][:type]
            
            location_map.merge!({ hexmap[x][y][:type] => 1 }) { |key, old_count, new_count| old_count + new_count }
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

def determine_heightmap(hexmap)
  
  pfsize = 2
  
  while (pfsize**2 + 1) < $height or (pfsize**2 + 1) < $width
    puts "plasma fractal size is " + pfsize.to_s
    pfsize += 2
  end
  
  puts "plasma fractal size is " + (pfsize**2).to_s
  fractal = PlasmaFractal.new(:size =>(pfsize**2)+1, :height_seed => 100)
  fractal.generate!
  
  for x in 0..$width-1
    for y in 0..$height-1
      hexmap[x][y][:height] = fractal.data[x][y]
    end
  end
  
  
  $mountain_threshold = 0.90 * fractal.max.to_f
  $hill_threshold = 0.80 * fractal.max.to_f
  $plain_threshold = 0.60 * fractal.max.to_f
  
end


def determine_terrain(hexmap)

  for x in 0..$width-1
    for y in 0..$height-1

      v = hexmap[x][y][:height]
      
      if v.to_f > $mountain_threshold
        #puts "%02d" % x + "%02d" %y + " height was #{v} and threshold was #{mountain_threshold} so setting mountain"
        hexmap[x][y][:terrain] = "mountain"
      elsif v.to_f <= $mountain_threshold and v.to_f > $hill_threshold
        #puts "%02d" % x + "%02d" %y + " height was #{v} and threshold was #{hill_threshold} so setting hill"
        hexmap[x][y][:terrain] = "hill"
      elsif v.to_f <= $hill_threshold and v.to_f > $plain_threshold
        #puts "%02d" % x + "%02d" %y + " height was #{v} and threshold was #{plain_threshold} so setting plain"
        hexmap[x][y][:terrain] = "plain"
      else
        #puts "%02d" % x + "%02d" %y + " height was #{v} so setting sea"
        hexmap[x][y][:terrain] = "sea"
      end
      
      
    end
  end

end

def generate_map_pdf(pdf, width, height, axis, strength)
  
  $width = width
  $height = height
  hexmap = Array.new($width) { Array.new($height) }
  
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
    
  for x in 0..$width-1
    for y in 0..$height-1
      generate_hex(hexmap, x, y)
    end
  end

  determine_heightmap(hexmap)
  calculate_drainage(hexmap)
  determine_terrain(hexmap)
 
  display_map(hexmap)
    
  return generate_pdf(pdf, hexmap)
  
end

def display_map(hexmap)
  
  for x in 0..$width-1
    for y in 0..$height-1
          
      v = hexmap[x][y][:terrain]
      d = hexmap[x][y][:drainage][:value].to_i
      
      if d > 50 and v != "sea"
        print "o"
      elsif v == "mountain"
        print "M"
      elsif v == "hill"
        print "m"
      elsif v == "plain"
        print "_"
      else
        print "s"
      end
      
      


    end
    puts
  end
end

def display_drainage(hexmap)
  
  for x in 0..$width-1
    for y in 0..$height-1
          
      v = hexmap[x][y][:drainage][:value].to_i
      
      if v > 50
        print "d"
      else
        print "_"
      end
      
    end
    puts
  end
end


