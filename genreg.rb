require "prawn"


$number_of_locations = 45

sin60 = 0.866025404
$C = 11
$A = 0.5*$C
$B = $C*sin60
puts $A
puts $B
puts $C
$hex_bases = [ [0, $B], [$A, 0], [$A+$C, 0], [2*$C, $B], [$A+$C, 2*$B], [$A, 2*$B]]

$pdf = Prawn::Document.new(:margin => [0.25,0.25,0.25,0.25])

$width = 30
$height = 40
$max_height = $height*(2*$B)
$hbias = 0.0 
$vbias = 0.0
$total_bias = ($hbias.abs.to_f+$vbias.abs.to_f)/2.0

$hexmap = Array.new($width+1) { Array.new($height+1)  }

def draw_hex(x,y, marker, type="")

  if x % 2 == 0
    x_offset = x * ($A+$C)
    y_offset = y * (2*$B)
  else
    x_offset = x * ($A+$C)
    y_offset = (y * (2*$B)) - $B
  end
  y_offset = $max_height - y_offset
  
  coords = $hex_bases.map { | coordinate| [coordinate[0]+x_offset, coordinate[1]+y_offset] }
  $pdf.stroke_polygon *coords
  
  if marker
    if type == "dungeon"
      $pdf.fill_ellipse [x_offset+$C, y_offset+$B], 5
    elsif type == "megadungeon"
      $pdf.fill_ellipse [x_offset+$C, y_offset+$B], 7
    elsif type == "lair"
      $pdf.fill_ellipse [x_offset+$C, y_offset+$B], 3
      
    elsif type == "settlement"
      $pdf.stroke_rectangle [x_offset+$C-2.5, y_offset+$B+2.5], 5, 5
    end
  end
  
  $pdf.font_size(4)
  $pdf.draw_text "%02d" % x + "%02d" % y,
             :at => [x_offset+$C-3, y_offset+$B-7]
  
  
end

def generate_ruin_or_lair(x,y)

  roll = rand(30)

  type = ""
  case roll 
  when 0..3 
    puts "\t\tmegadungeon (6-10 sessions)"
    type = "megadungeon"
    draw_hex(x,y, true, "megadungeon")
  when 3..13
    puts "\t\tdungeon (1-2 sessions)"
    type = "dungeon"
    draw_hex(x,y, true, "dungeon")
  else
    puts "\t\tsmall lair (1-3 encounters)"
    type = "lair"
    draw_hex(x,y, true, "lair")
  end

  $hexmap[x][y] = { :x => x, :y => y, :type => type }
end

def generate_hex(x, y)

  if rand($width*$height) <= $number_of_locations
    puts "\tsomething at " + "%02d" % x + "%02d" % y

    roll = rand(100)
    vbias = ((y.to_f/$height.to_f*$vbias) + (-1*($vbias/2.0)))
    hbias = ((x.to_f/$width.to_f*$hbias)+ (-1*($hbias/2.0)))
    
    puts "roll #{roll}"
    if $total_bias == 0
      bias = 0
    else
      bias = (vbias.abs.to_f/$total_bias)*vbias.to_f + (hbias.abs.to_f/$total_bias)*hbias.to_f
    end
    
    puts "bias = #{hbias} #{vbias} #{bias}"
    roll += bias
    puts "roll #{roll}"
    
    if (roll <= 33)
      puts "\t\tsettlement"
      $hexmap[x][y] = { :x => x, :y => y, :type => "settlement" }
      
      draw_hex(x,y, true, "settlement")
    else
      generate_ruin_or_lair(x,y)
    end
      
  else
    draw_hex(x,y, false)
  end
end


for x in 1..$width
  for y in 1..$height
    generate_hex(x,y)
  end
end

$pdf.start_new_page
$pdf.move_down 10
$pdf.font_size(12)
$pdf.text "Region Key"

$pdf.column_box([0, $pdf.cursor],:columns => 2, :width => 500) do
    for x in 1..$width
      for y in 1..$height
        if $hexmap[x][y]

          $pdf.text  "Hex " + ("%02d" % $hexmap[x][y][:x] + "%02d" % $hexmap[x][y][:y]) + 
            " - a " + $hexmap[x][y][:type]
        end
      end
    end
end
  


$pdf.render_file "hexagon.pdf"

