local GRID = {}
local GRID_SIZE = 10
local cristals = {'A', 'B', 'C', 'D', 'E', 'F'}
local E_Cristal = ' '      
math.randomseed(os.time())

local function Sb_Table(t, exclude)
  local sub = {}
  for i=0,#t do
    if i ~= exclude then
      sub[#sub + 1] = t[i]
    end
  end
  return sub
end
function GRID.mix()
  for i=1,GRID_SIZE do
    GRID[i] = {}    
    for j=1,GRID_SIZE do
      subCristalsTable = cristals
      cristalsCount = #cristals
      index = math.random(cristalsCount) 
      newCristall = subCristalsTable[index]
      if i>2 then
        if (GRID[i-1][j] == newCristall and GRID[i-2][j] == newCristall) then
          cristalsCount = cristalsCount - 1
          subCristalsTable = Sb_Table(subCristalsTable, index)
          
          index = math.random(cristalsCount)
          newCristall = subCristalsTable[index]
        end
      end
      if j>2 then
        if (GRID[i][j-1] == newCristall and GRID[i][j-2] == newCristall) then
          cristalsCount = cristalsCount - 1
          subCristalsTable = Sb_Table(subCristalsTable, index)
          index = math.random(cristalsCount)
          newCristall = subCristalsTable[index]
        end
      end
      GRID[i][j] = newCristall
    end
  end
end  
function GRID.move(from, to)  
  cristal = GRID[from.y][from.x]  
  GRID[from.y][from.x] = GRID[to.y][to.x]
  GRID[to.y][to.x] = cristal
end
local function checkHorizont(location)
  X, Y = location.x, location.y
  matchedCells = {}
  if X - 1 > 0 and GRID[Y][X] == GRID[Y][X - 1] then
    matchedCells[#matchedCells + 1] = {x = X - 1, y = Y}
    if X - 2 > 0 and GRID[Y][X] == GRID[Y][X - 2] then
      matchedCells[#matchedCells + 1] = {x = X - 2, y = Y}    
    end
  end
  if X + 1 < GRID_SIZE and GRID[Y][X] == GRID[Y][X + 1] then
    matchedCells[#matchedCells + 1] = {x = X + 1, y = Y}
    if X + 2 < GRID_SIZE and GRID[Y][X] == GRID[Y][X + 2] then
      matchedCells[#matchedCells + 1] = {x = X + 2, y = Y}    
    end
  end 
  
  if #matchedCells > 1 then  
    for key, val in pairs(matchedCells) do 
      table.insert(_G['matched'], val)      
    end
    return true  
  end
  return false  
end 
local function checkVertical(location)
  X, Y = location.x, location.y
  matchedCells = {}
  if Y - 1 > 0 and GRID[Y][X] == GRID[Y - 1][X] then
    matchedCells[#matchedCells + 1] = {x = X, y = Y - 1}
    if Y - 2 > 0 and GRID[Y][X] == GRID[Y - 2][X] then
      matchedCells[#matchedCells + 1] = {x = X, y = Y - 2}    
    end
  end
  if Y + 1 < GRID_SIZE and GRID[Y][X] == GRID[Y + 1][X] then
    matchedCells[#matchedCells + 1] = {x = X, y = Y + 1}
    if Y + 2 < GRID_SIZE and GRID[Y][X] == GRID[Y + 2][X] then
      matchedCells[#matchedCells + 1] = {x = X, y = Y + 2}    
    end
  end 
  
  if #matchedCells > 1 then  
    for key, val in pairs(matchedCells) do
      table.insert(_G['matched'], val)
    end
    return true  
  end
  return false  
end 
local function checkPoint(point)
  count = #_G['matched']
  isMatchedVertical = checkVertical(point)
  isMatchedHorizont = checkHorizont(point)
  
  if count < #_G['matched'] then
    table.insert(_G['matched'], point)
  end
  return isMatchedHorizont or isMatchedVertical
end
local function isHavePossibleMoves()
  for i = 1, GRID_SIZE do
    for j = 1, GRID_SIZE do
      element = GRID[i][j]
      if m == GRID[i+1][j] then
        if i < 8 and element == GRID[i + 3][j] then return false end
        if j < 10 and i < 9 and element == GRID[i + 2][j + 1] then return false end
        if j > 1 and i < 9 and element == GRID[i + 2][j - 1] then return false end
        
        if i > 2 and element == GRID[i - 2][j] then return false end
        if j < 10 and i > 1 and element == GRID[i - 1][j + 1] then return false end
        if j > 1 and i > 1 and element == GRID[i - 1][j - 1] then return false end
      end
      if element == GRID[i][j+1] then
        if j < 8 and element == GRID[i][j + 3] then return false end
        if i < 10 and j < 9 and element == GRID[i + 1][j + 2] then return false end
        if i > 1 and j < 9 and element == GRID[i - 1][j + 2] then return false end
        
        if j > 2 and element == GRID[i][j - 2] then return false end
        if i < 10 and j > 1 and element == GRID[i + 1][j - 1] then return false end
        if i > 1 and j > 1 and element == GRID[i - 1][j - 1] then return false end
      end
    end
  end
  return true
end
function GRID.checkPossibleMove()
  if isHavePossibleMoves() then
    GRID.mix()
    _G['Msg'] = "Error: Mix complited. No possible move"
  end
end
local function clearMatchedLines()
  if #_G['matched'] < 1 then return false end
  
  for key, val in pairs(_G['matched']) do
    GRID[val.y][val.x] = E_Cristal
  end
    
  _G['P_c'] = _G['P_c'] + #_G['matched']  
  if _G['Combo'] > 3 then
    _G['P_c'] = _G['P_c'] + #_G['matched']
  elseif _G['Combo'] > 0 then
    _G['P_c'] = _G['P_c'] + _G['Combo']
  end  
  _G['Combo'] = _G['Combo'] + 1  
end
function GRID.checkMatched(from, to)
  isMatchedFrom = checkPoint(from)
  isMatchedTo = checkPoint(to)
  
  clearMatchedLines()
  return isMatchedFrom or isMatchedTo
end
local function isPossibleMatches()
  iterFlag = false
  for i=1, GRID_SIZE do
    for j=1, GRID_SIZE do
      iterFlag = iterFlag or checkPoint({x=j, y=i})
    end
  end
  return iterFlag    
end
function GRID.checkPossibleMatches(dump)
  flag = true
  while flag do
    iterFlag = isPossibleMatches()    
    clearMatchedLines()    
    dump()
    flag = flag and iterFlag    
  end
end
return GRID