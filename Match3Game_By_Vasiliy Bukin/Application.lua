local Hud = require('HUD')
local Input_m = require('Input Manager')
local GS = require('GameScreen')


local cristals = {'A', 'B', 'C', 'D', 'E', 'F'}
  _G['matched'] = {}        
  _G['Msg'] = "Start game"    -- Status 
  _G['P_c'] = 0               -- Points counter 
  _G['Combo'] = 0           -- Combo counter
  _G['Turns_l'] = 400       -- Turns left

 
function init()
  GS.mix() 
  Hud.DrawGrid(GS)
end
function tick()
  os.execute("timeout 1 > nul")  
  if _G['Turns_l'] <= 0 then
    _G['Msg'] = "Time is over"  
    _G['P_c'] = _G['P_c'] - 1
  else
    _G['Turns_l'] = _G['Turns_l'] - 1
  end  
end
function dump()
  _G['Msg'] = "Ok!"  
  local matched = _G['matched']
  table.sort(matched, function (a, b) return a.y < b.y end)
  for i =1, #matched do
    X, Y = matched[i].x, matched[i].y
    while true do
      tick()
      Hud.DrawGrid(GS)
      if Y == 1 then
        GS[Y][X] = cristals[math.random(#cristals)]
        break
      else
        temp = GS[Y][X]
        GS[Y][X] = GS[Y-1][X]
        GS[Y-1][X] = temp
        Y = Y - 1
      end      
    end
    Hud.DrawGrid(GS)
  end    
  _G['matched'] = {}
end  
init()
while true do  
  if _G['Turns_l'] <= 0 then break end  
  
  from, to, isExit = Input_m .readPoints()  
  if isExit then break end
  
  if to == nil then         
    if (from == nil) then   
      _G['Msg'] = "Error:Wrong command"          
    end 
    goto continue
  end
  
  GS.move(from, to) 
  tick()                
  Hud.DrawGrid(GS) 
    
  isMatched = GS.checkMatched(from, to) 
  if isMatched then                         
    dump()                                  
    GS.checkPossibleMatches(dump)       
    GS.checkPossibleMove()              
  else                   
    GS.move(to, from)                   
    _G['Msg'] = "There is no match"
    _G['combo'] = 0                           
  end  
  ::continue::
  Hud.DrawGrid(GS)
end