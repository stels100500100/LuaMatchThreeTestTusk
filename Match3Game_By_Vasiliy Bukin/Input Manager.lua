local I_Controller = {}
local MoveCommands = {['u'] = 'Up', ['l'] = 'Left', ['r'] = 'Right', ['d'] = 'Down'}


local function isInvalid(commands)
    return (#commands ~=4 or commands[1] ~= 'm' 
    or tonumber(commands[2]) < 0 or tonumber(commands[2]) > 9 
    or tonumber(commands[3]) < 0 or tonumber(commands[3]) > 9
    or (string.match("urld", commands[4]) == nil))
end  
local function split(s)
    delimiter = ' '
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local function MoveTo(from, toDirecion)
  result = {x = from.x, y = from.y}
  if toDirecion == 'u' and from.y > 1 then
    result.y = from.y - 1  
  elseif toDirecion == 'l' and from.x > 1 then
    result.x = from.x - 1  
  elseif toDirecion == 'r' and from.x < 10 then
    result.x = from.x + 1  
  elseif toDirecion == 'd' and from.y < 10 then
    result.y = from.y + 1
  else
    _G['Msg'] = "Error: There's a wall you can't move there " .. MoveCommands[toDirecion] .. "!"
    return nil
  end  
  return result
end
function I_Controller.readPoints()
  commandLine = io.read()
  if commandLine == 'q' or commandLine == 'Q' then 
    return nil, nil, true 
  end
   
  commands = split(commandLine)
  if isInvalid(commands) then
    return nil, nil, false
  end  
  
  X, Y = commands[2] + 1, commands[3] + 1    
  from = {x=X, y=Y}
  to = MoveTo(from, commands[4])

  return from, to, false
end

return I_Controller