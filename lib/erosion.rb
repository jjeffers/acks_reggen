module Erosion
  
  def self.erode(hmap, wmap, smap)
    kr = 1.0
    ks = 0.01
    ke = 0.5
    kc = 0.01
    
    add_rain(wmap, kr)
    erode_soil(hmap, wmap, smap, ks)
    disperse_water(hmap, wmap, smap)
    evaporate_water(hmap, wmap, smap, ke, kc)
    
  end
  
  def self.add_rain(wmap, kr)
    
    wmap.each_with_index do |row, index|
      row.each_with_index do |cell, cindex|
        wmap[index][cindex] += kr
      end
    end
        
  end
  
  def self.erode_soil(hmap, wmap, smap, ks)
    
    hmap.each_with_index do |row, index|
      row.each_with_index do |cell, cindex|
        sediment_removed = wmap[index][cindex]*ks
        hmap[index][cindex] -= sediment_removed
        smap[index][cindex] += sediment_removed
      end
    end
    
  end
  
  def self.disperse_water(hmap, wmap, smap)
    
    hmap.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        
        neighbor_altitude_total = 0
        current_cell_altitude = hmap[x][y] + wmap[x][y]
        number_of_neighbors = 0
        total_delta_altitude = 0
        
        hex_neighbors(hmap, x, y) do |i, j, neighbor_cell|
          neighbor_altitude = hmap[i][j] + wmap[i][j]
          
          if current_cell_altitude > neighbor_altitude
            neighbor_altitude_total += hmap[i][j] + wmap[i][j]
            total_delta_altitude += (current_cell_altitude - neighbor_altitude)
            number_of_neighbors += 1
          end
          
        end
        
        average_neighbor_altitude = neighbor_altitude_total/number_of_neighbors.to_f
        
        delta_altitude = current_cell_altitude - average_neighbor_altitude
        
        current_water = wmap[x][y]
        current_sediment = smap[x][y]
        
        hex_neighbors(hmap, x, y) do |i, j, neighbor_cell|
          neighbor_altitude = hmap[i][j] + wmap[i][j]
          
          if current_cell_altitude > neighbor_altitude
            neighbor_altitude_total += hmap[i][j] + wmap[i][j]
            
            delta_altitude_i = (current_cell_altitude - neighbor_altitude)
  
            delta_wi = [current_water, delta_altitude].min * (delta_altitude_i/total_delta_altitude)
            delta_mi = current_sediment * delta_wi/current_water
            
            wmap[x][y] -= delta_wi
            wmap[i][j] += delta_wi
            
            smap[x][y] -= delta_mi
            smap[i][j] += delta_mi
          end
          
        end
        
      end
    end
    
  end
  
  def self.evaporate_water(hmap, wmap, smap, ke, kc)
    
    hmap.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        wmap[x][y] -= (wmap[x][y]*ke)

        sediment_max = wmap[x][y]*kc
        
        delta_m = [0, (smap[x][y] - sediment_max)].max
        smap[x][y] -= delta_m
        hmap[x][y] += delta_m
        
      end
    end
         
  end
  
end