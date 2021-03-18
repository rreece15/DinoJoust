WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


Class = require 'class'
push = require 'push'

require 'util'
require 'Player'
require 'Map'

gameState = 'start'
winner = ''

Summer = love.graphics.newFont('Fonts/Summer.ttf')
Bold = love.graphics.newFont('Fonts/Bold.ttf')
Font = love.graphics.newFont('Fonts/font.ttf')

instructions = false

function love.load()
    math.randomseed(os.time())

    love.window.setTitle('Dino Joust!')

    sounds = {
        ['Hurt'] = love.audio.newSource('Sounds/Hurt.wav', 'static'),
        ['Jump'] = love.audio.newSource('Sounds/Jump.wav', 'static'),
        ['Select'] = love.audio.newSource('Sounds/Select.wav', 'static')
    }

    map = Map()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        sounds['Select']:play()
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'end' then
            gameState = 'start'
        end
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    mouse_x = love.mouse.getX()
    mouse_y = love.mouse.getY()

    map:update(dt)

    if gameState ~= start then
        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(67/255, 31/255, 59/255, 255/255)

    map:render()

    if gameState == 'start' then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(Bold, 30)
        love.graphics.printf("Dino Joust!", 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(Font, 18)
        --love.graphics.print("MOuse X:".. mouse_x.. "Mouse Y: "..mouse_y, 10, 20)
        love.graphics.printf("Enter to Start.", 0, 150, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Instructions", 0, 175, VIRTUAL_WIDTH, 'center')
        if mouse_x >= 500 and mouse_x <= 750 and mouse_y >= 500 and mouse_y <= 550 then
            instructions = true
            love.graphics.setFont(Summer, 12)
            love.graphics.print("Be the last dino remaining!", 40, 175)
            love.graphics.print("Jump on the others to win!", 40, 190)
            love.graphics.print("Three Lives!", 40, 205)
            love.graphics.print("Controls: Up, Down, Left, Right", 300, 160)
            love.graphics.print("Blue: W, S, A, D", 300, 175)
            love.graphics.print("Red: Up, Down, Left, Right", 300, 190)
            love.graphics.print("Green: I, K, J, L", 300, 205)
            love.graphics.print("Yellow: T, G, F, H", 300, 220)
        else
            instructions = false
        end
    elseif gameState == 'end' then
        love.graphics.printf(winner .. " wins! Enter for HomeScreen.", 0, 100, VIRTUAL_WIDTH, 'center')
    end
    push:apply('end')
end