
local composer = require( "composer" )
local physics = require("physics")

physics.start()
physics.setGravity(0, 0)

local fondo = display.newImageRect("fondo.jpg",720,1120)
fondo.anchorx = 0
fondo.x = display.contentCenterX 
fondo.y = display.contentCenterY

local golpe = audio.loadSound ("golpe.mp3")
local game = audio.loadSound ("gameover.mp3")

--physics.setDrawMode("hybrid")

-- Constantes
local typeLetter = "Chalkduster"

local _w = display.contentCenterX;          
local _W = display.contentWidth;
local _h = display.contentCenterY;
local _H = display.contentHeight;

local paddingUp = _H * 0.1;
local paddingLeft = _W * 0.05;

local rows = 10
local colums =  10

local height = _h/rows;
local width = (_W - paddingLeft * 2 )/colums;

local grill = {};

-----------Constantes Paleta-------
local widthPaleta = _W * 0.2
local heightPaleta = _H * 0.02
local strokeWidthPaleta = 3
local paleta

local totalPoints = 0
local pointsTag
local scoreBoardPoints
local gameOverText

--Constants Ball
local ratioBall = height * 0.25
local ball 

--------------Functions------------
local paletaMove
local toCollision


---------------Points--------------
pointsTag = display.newText("Puntos:", 0, 0, typeLetter, paddingUp * 0.45 )
pointsTag.x = _w - pointsTag.width * 0.5
pointsTag.y = paddingUp * 0.5 + pointsTag.height * 0.5
pointsTag:setTextColor(1, 1, 0, 1)


scoreBoardPoints = display.newText(totalPoints, 0, 0, typeLetter, paddingUp * 0.45)
scoreBoardPoints.x = pointsTag.x + pointsTag.width 
scoreBoardPoints.y = pointsTag.y 
scoreBoardPoints:setTextColor(1, 1, 0, 1)


for i = 1,rows do
    grill[i] = {}       -- Reservamos memoria para cada fila
    for j = 1,colums do
        grill[i][j] = display.newRect( 
                        paddingLeft - width * 0.5 + j * width, 
                        paddingUp - width * 0.5 + i * width , 
                        width, 
                        width)
        local casilla =  grill[i][j]
        if (i%2 == 1) then
            casilla:setStrokeColor(1, 0, 0, 1)
            
            casilla.strokeWidth = 2
            casilla.life = 0
            casilla.points = 20
        else
            casilla:setFillColor(1, 1, 0, 1);
            casilla:setStrokeColor(1, 0, 0, 1)
            casilla.strokeWidth = 2
            casilla.life = 1
            casilla.points = 50
        end  
        physics.addBody(casilla, "static")     
    end
end


paleta = display.newImage ("lapiz.png", 0,0)
paleta.x = _w
paleta.y = _H * 0.98
--paleta.strokeWidth = strokeWidthPaleta
--paleta:setStrokeColor(1, 1, 0.2, 1)
--paleta:setFillColor(0.6, 0.2, 0, 1, 1)
physics.addBody(paleta, "static", { bounce = 1  })


paletaMove = function (event)
    local phase = event.phase
    
    if phase == "began" then
        display.getCurrentStage():setFocus(event.target)
    elseif phase == "moved" then
        paleta.x = event.x 
    else 
        display.getCurrentStage():setFocus(nil)
    end
end

Runtime:addEventListener("touch", paletaMove)
--paleta:addEventListener("touch", paletaMove)


--Ball
ball = display.newImage ("bola.png", 0,0)
ball.x = paleta.x
ball.y = paleta.y - paleta.height * 1.25

--ball:setFillColor(1, 0, 1, 1)


physics.addBody(ball, "dynamic",{ radius = ratioBall, bounce =1 } )
ball:setLinearVelocity(0 * math.random(300, 400), -math.random(300, 400))


--Limits Creation

    --Up
    
    local limitUp = display.newRect(_w, 0, _W, 1)

    limitUp:setFillColor(0, 0, 0, 1)
    physics.addBody(limitUp, "static", { })
    
    --Right
    
    local limitRight = display.newRect(_W -1 , _h, 1, _H)
    limitRight:setFillColor(0, 0, 0, 1)
    physics.addBody(limitRight, "static", { })
    
    --Left
    
    local limitLeft = display.newRect(0, _h, 1, _H)
    limitLeft:setFillColor(0, 0, 0, 1)
    physics.addBody(limitLeft, "static", { })
    
    --Down
    
    local limitDown = display.newRect(_w, _H, _W, 1)
    limitDown:setFillColor(0, 0, 0, 1)
    physics.addBody(limitDown, "static", { })
    limitDown.ground = true


----------------Colisions---------------- 
toCollision = function (self, event)
    local phase = event.phase
    local other = event.other
    local ball = self
    
    if event.phase == "ended" then
        if other.ground then
            gameOverText = display.newImage ("gameover.png")
            --gameOverText:setTextColor(0, 0, 0, 1)
            gameOverText.x = _w
            gameOverText.y = _h
            ball:setLinearVelocity(0,0)
            audio.play(game)
            paleta:removeEventListener("touch", paletaMove)

            
        else
            if other.life == 0 then
            totalPoints = totalPoints + other.points
            scoreBoardPoints.text = totalPoints
            display.remove(other)
            audio.play(golpe)
            elseif other.life == 1 then
                other.life = other.life - 1
                other:setFillColor(1, 1, 1, 1);
                audio.play(golpe)
            end
        end
    end
    
    
end
ball.collision = toCollision
ball:addEventListener("collision", ball)




