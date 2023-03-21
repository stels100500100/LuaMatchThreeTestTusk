local interface = {}

function interface.DrawGrid(InGRID)
 os.execute("cls")
  print("               Match 3 in line") 
  print("")
  print("   0 1 2 3 4 5 6 7 8 9     Status: " .. _G['Msg'])
  print("   -------------------")
  for i=1,10 do
    row = i-1 .. "| " .. table.concat(InGRID[i], " ")
    if i == 1 then 
      row = row .. "  Score: " .. _G['P_c']
      if _G['Combo'] > 3 then
        row = row .. "  Combo: X2"        
      elseif _G['Combo'] > 0 then
        row = row .. "  Combo: +" .. _G['Combo']        
      end
      
    elseif i == 2 then
      row = row .. "  Tick: " .. _G['Turns_l'] 
    elseif i == 4 then 
      row = row .. "      Control commands:"
    elseif i == 5 then 
      row = row .. "      command example      > m 3 0 r     then press ENTER"
    elseif i == 6 then 
      row = row .. "      m - Move cristal "
    elseif i == 7 then 
      row = row .. "      3 0 - X Y coordinates of cristal that you wnat to move"
    elseif i == 8 then 
      row = row .. "      r,l,u,d, - move direction"
    elseif i == 9 then 
      row = row .. "      Q/q -Exit the game" 
    end
  
    print(row)    
  end 
  print("   ")
  print("   ")
end

return interface
