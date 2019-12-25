love.window.setTitle "GBSprite";
love.graphics.setDefaultFilter("nearest","nearest")
--love.graphics.setNewFont("Fonts/uni05_53.ttf",25)
love.graphics.setNewFont(40)

love.window.setFullscreen(false)
love.window.setMode(0,0,{resizable=false})

love.window.setMode(1920,1920,{resizable = false})

local quitting = 0

local color = 0
local image = {}
for i=1, 16 do
  image[i] = {0,0,0,0,0,0,0,0} -- *2+1
end

function tobytes()
  local s = ""
  for i=1, 16 do
    local row = image[i]
    local upper = 8*row[1] + 4*row[2] + 2*row[3] + 1*row[4]
    local lower = 8*row[5] + 4*row[6] + 2*row[7] + 1*row[8]
    s = s.."$"
    s = s..string.format("%X", upper)
    s = s..string.format("%X", lower)
    if i < 16 then s = s..", " end
  end
  return s
end

function love.load()
end

function pixelPos(x,y)
  return (math.floor(x/200)), (math.floor(y/200))
end

function love.wheelmoved(x,y)
  if y > 0 then
    if color < 3 then
      color = color + 1
    end
  elseif y < 0 then
    if color > 0 then
      color = color - 1
    end
  end
end

function love.keypressed(key)
  if key == "escape" then love.event.quit()
  elseif key == "n" and quitting == 1 then quitting = 0
  elseif key == "y" and quitting == 1 then quitting = 2; love.event.quit()
  end
end

function love.mousepressed(x,y, button)
  if button == 1 and x <= 1600 and y <= 1600 then
    local px, py = pixelPos(x,y)
    local b1,b2 = 0,0
    if color == 1 then
      b1,b2 = 0,1
    elseif color == 2 then
      b1,b2 = 1,0
    elseif color == 3 then
      b1,b2 = 1,1
    end
    image[py*2+1][px+1] = b1
    image[py*2+2][px+1] = b2
  end
end

function love.update(dt)
end


function love.draw()
  for i=1, 8 do
    for j=1, 8 do
      local b = 10*image[2*i-1][j] + image[2*i][j]
      if b == 00 then
        love.graphics.setColor(0,0,0)
      elseif b == 01 then
        love.graphics.setColor(0.333,0.333,0.333)
      elseif b == 10 then
        love.graphics.setColor(0.666,0.666,0.666)
      elseif b == 11 then
        love.graphics.setColor(1,1,1)
      end
      love.graphics.rectangle("fill", 200*(j-1), 200*(i-1), 200, 200)
    end
  end

  love.graphics.setColor(1,1,1)
  love.graphics.print("color: "..tostring(color), 50,1700)
  if quitting == 1 then love.graphics.print("quit? y/n", 50, 1800) end
  love.graphics.rectangle("line",0,0,1600,1600)

  local x,y = love.mouse.getPosition()
  local px, py = pixelPos(x,y)
  if x < 1600 and y < 1600 then
    love.graphics.print("pos: "..tostring(px)..", "..tostring(py), 50, 1650)
    love.graphics.rectangle("line", 200*px,200*py, 200,200)
  end
end

function love.quit()
  if quitting == 0 then
    quitting = 1
  elseif quitting == 2 then
    print(tobytes())
    return false
  end
  return true
end
