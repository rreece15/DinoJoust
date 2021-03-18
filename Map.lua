require 'util'

require 'Player'
require 'Player2'
require 'Player3'
require 'Player4'

Map = Class{}

TILE_EMPTY = 1
FLOOR = 15
FLOOR_END = 16

LAVA = 69
LAVA_FLOOR = 85
LAVA_START = 61
LAVA_END = 77

CAVE1 = 2
CAVE2 = 3
CAVE3 = 5
CAVE4 = 6
CAVE5 = 7

TORCH = 46
TORCH_END = 54
BIRD1 = 42
BIRD2 = 50

players = 4



function Map:init()
    self.spritesheet = love.graphics.newImage('Graphics/cave_tiles.png')
    self.tileWidth = 8
    self.tileHeight = 8
    self.mapWidth = 54
    self.mapHeight = 31
    self.tiles = {}

    self.music = love.audio.newSource('Sounds/Boss.mp3', 'static')

    self.player = Player(self)
    self.player2 = Player2(self)
    self.player3 = Player3(self)
    self.player4 = Player4(self)

    self.gravity = 15

    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight
    
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if math.random(10) == 1 then
                self:setTile(x, y, CAVE1)
            elseif math.random(10) == 1 then
                self:setTile(x, y, CAVE2)
            elseif math.random(10) == 1 then
                self:setTile(x, y, CAVE3)
            elseif math.random(10) == 1 then
                self:setTile(x, y, CAVE4)
            elseif math.random(10) == 1 then
                self:setTile(x, y, CAVE5)
            end
        end
    end

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if math.random(100) == 1 then
                self:setTile(x, y, BIRD1)
            elseif math.random(100) == 1 then
                self:setTile(x, y, BIRD2)
            end
        end
    end


    for x = math.floor(self.mapWidth / 3), math.floor( 2 * self.mapWidth / 3) do
        self:setTile(x, self.mapHeight - 2, FLOOR)
    end

    for x = 1, math.floor(self.mapWidth / 3) do
        self:setTile(x, math.floor(2 * self.mapHeight / 3), FLOOR)
        self:setTile(self.mapWidth - x, math.floor(2 * self.mapHeight / 3), FLOOR)
    end

    for x = math.floor(self.mapWidth / 4), math.floor(3 * self.mapWidth / 4) do
        self:setTile(x, math.floor(self.mapHeight / 3), FLOOR)
    end

    for x = 5, self.mapWidth, 5 do
        self:setTile(x, 5, TORCH)
        self:setTile(x, 6, TORCH_END)
    end
    for y = 1, self.mapHeight do
        self:setTile(2, y, LAVA)
        self:setTile(3, y, LAVA)

        self:setTile(self.mapWidth - 2, y, LAVA)
        self:setTile(self.mapWidth - 3, y, LAVA)

    end

    for x = 1, self.mapWidth do
        self:setTile(x, self.mapHeight - 1, LAVA_FLOOR)
        self:setTile(x, self.mapHeight, LAVA)
    end

    self:setTile(2, 1, LAVA_START)
    self:setTile(3, 1, LAVA_START)

    self:setTile(self.mapWidth - 2, 1, LAVA_START)
    self:setTile(self.mapWidth - 3, 1, LAVA_START)

    self:setTile(2, self.mapHeight - 2, LAVA_END)
    self:setTile(3, self.mapHeight - 2, LAVA_END)

    self:setTile(self.mapWidth - 2, self.mapHeight - 2, LAVA_END)
    self:setTile(self.mapWidth - 3, self.mapHeight - 2, LAVA_END)

    self.music:setLooping(true)
    self.music:setVolume(.25)
    self.music:play()
end

function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        FLOOR
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
    if players == 1 then
        if self.player.score ~= 0 then
            winner = 'Player 1'
            gameState = 'end'
        elseif self.player2.score ~= 0 then
            winner = 'Player 2'
            gameState = 'end'
        elseif self.player3.score ~= 0 then
            winner = 'Player 3'
            gameState = 'end'
        elseif self.player4.score ~= 0 then
            winner = 'Player 4'
            gameState = 'end'
        end
    end

    if gameState == 'play' then
        self.player:update(dt)
        self.player2:update(dt)
        self.player3:update(dt)
        self.player4:update(dt)
    elseif gameState == 'end' then
        self.player:update(dt)
        self.player2:update(dt)
        self.player3:update(dt)
        self.player4:update(dt)
    elseif gameState == 'start' then
        players = 4
        self.player:reset()
        self.player2:reset()
        self.player3:reset()
        self.player4:reset()

        self.player:update(dt)
        self.player2:update(dt)
        self.player3:update(dt)
        self.player4:update(dt)
    end

    if self.player.state ~= 'loss' then
        self.player:checkDamage()
    end

    if self.player2.state ~= 'loss' then
        self.player2:checkDamage()
    end

    if self.player3.state ~= 'loss' then
        self.player3:checkDamage()
    end

    if self.player4.state ~= 'loss' then
        self.player4:checkDamage()
    end

    if (self.player:collides(self.player2) and self.player2.dy > 0) or (self.player:collides(self.player3) and self.player3.dy > 0) or (self.player:collides(self.player4) and self.player4.dy > 0) then
        sounds['Hurt']:play()
        if self.player:collides(self.player4) then
            self.player4.dy = -JUMP_VELOCITY
        elseif self.player:collides(self.player2) then
            self.player2.dy = -JUMP_VELOCITY
        elseif self.player:collides(self.player3) then
            self.player3.dy = -JUMP_VELOCITY
        end
        self.player.score = self.player.score - 1
        self.player.state = 'hurt'
        self.player.animation = self.player.animations['hurt']
    elseif (self.player2:collides(self.player) and self.player.dy > 0) or (self.player2:collides(self.player3) and self.player3.dy > 0) or (self.player2:collides(self.player4) and self.player4.dy > 0) then
        sounds['Hurt']:play()
        if self.player2:collides(self.player) then
            self.player.dy = -JUMP_VELOCITY
        elseif self.player2:collides(self.player4) then
            self.player4.dy = -JUMP_VELOCITY
        elseif self.player2:collides(self.player3) then
            self.player3.dy = -JUMP_VELOCITY
        end
        self.player2.score = self.player2.score - 1
        self.player2.state = 'hurt'
        self.player2.animation = self.player2.animations['hurt']
    elseif (self.player3:collides(self.player) and self.player.dy > 0) or (self.player3:collides(self.player2) and self.player2.dy > 0) or (self.player3:collides(self.player4) and self.player4.dy > 0) then
        sounds['Hurt']:play()
        if self.player3:collides(self.player) then
            self.player.dy = -JUMP_VELOCITY
        elseif self.player3:collides(self.player2) then
            self.player2.dy = -JUMP_VELOCITY
        elseif self.player3:collides(self.player4) then
            self.player4.dy = -JUMP_VELOCITY
        end
        self.player3.score = self.player3.score - 1
        self.player3.state = 'hurt'
        self.player3.animation = self.player3.animations['hurt']
    elseif (self.player4:collides(self.player) and self.player.dy > 0) or (self.player4:collides(self.player2) and self.player2.dy > 0) or (self.player4:collides(self.player3) and self.player3.dy > 0) then
        sounds['Hurt']:play()
        if self.player4:collides(self.player) then
            self.player.dy = -JUMP_VELOCITY
        elseif self.player4:collides(self.player2) then
            self.player2.dy = -JUMP_VELOCITY
        elseif self.player4:collides(self.player3) then
            self.player3.dy = -JUMP_VELOCITY
        end
        self.player4.score = self.player4.score - 1
        self.player4.state = 'hurt'
        self.player4.animation = self.player4.animations['hurt']
    end

end


function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if x > self.mapWidth / 2 then
                local scaleX = -1
            else
                local scaleX = 1
            end

            if self:tileAt(x, y).id == FLOOR_END then
                love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)], 
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight, 
                0, scaleX, 1, 
                0, 0)
            else 
                love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight, 0, scaleX, 1, 0, 0)
            end
        end
    end
    self.player:render()
    self.player2:render()
    self.player3:render()
    self.player4:render()
end