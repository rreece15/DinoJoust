Player2 = Class{}

require 'Animation'


MOVE_SPEED = 100
JUMP_VELOCITY = 300
HURT_VELOCITY = 500

function Player2:init(map)
    self.width = 24
    self.height = 24

    self.score = 3

    self.map = map

    self.x = (map.mapWidth * map.tileWidth) - (map.mapWidth * map.tileWidth / 5)
    self.y = map.mapHeight * map.tileHeight / 2

    self.dx = 0
    self.dy = 0

    self.texture = love.graphics.newImage('Graphics/red.png')
    self.frames = generateQuads(self.texture, 24, 24)

    self.hearts = love.graphics.newImage('Graphics/hearts.png')
    self.heart = generateQuads(self.hearts, 16, 16)

    self.state = 'idle'
    self.direction = 'left'

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1], self.frames[2], self.frames[3], self.frames[4]
            }, 
            interval = 0.15
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5], self.frames[6], self.frames[7], self.frames[8], self.frames[9], self.frames[10], self.frames[11]
            },
            interval = 0.1
        },
        ['crouch_idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[19]
            },
            interval = 10
        }, 
        ['crouch_walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[20], self.frames[21],  self.frames[22],  self.frames[23],  self.frames[24]
            },
            interval = 0.1
        }, 
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[12], self.frames[13]
            },
            interval = 0.15
        },
        ['hurt'] = Animation {
            texture = self.texture, frames = {
                self.frames[15], self.frames[16], self.frames[17]
            }, 
            interval = 0.15
        },
        ['loss'] = Animation {
            texture = self.texture, frames = {
                self.frames[15], self.frames[16], self.frames[17]
            },
            interval = 0.15
        }
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviors = {
        ['idle'] = function(dt)
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('left') then
                self.dx = -MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'left'
                self.state = 'walking'
            elseif love.keyboard.isDown('up') then
                sounds['Jump']:play()
                self.dy = -JUMP_VELOCITY
                self.animation = self.animations['jumping']
                self.state = 'jumping'
            elseif love.keyboard.isDown('down') then
                if love.keyboard.isDown('left') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['crouch_walking']
                    self.direction = 'left'
                    self.state = 'crouch_walking'
                elseif love.keyboard.isDown('right') then
                    self.dx = MOVE_SPEED
                    self.direction = 'right'
                    self.state = 'crouch_walking'
                    self.animation = self.animations['crouch_walking']
                else
                    self.dx = 0
                    self.state = 'crouch_idle'
                    self.animation = self.animations['crouch_idle']
                end
            elseif love.keyboard.isDown('right') then
                self.dx = MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'right'
                self.state = 'walking'
            else
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.dx = 0
            end
            self:checkUpCollision()
        end,
        ['walking'] = function(dt)
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('left') then
                self.dx = -MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'left'
                self.state = 'walking'
            elseif love.keyboard.isDown('up') then
                sounds['Jump']:play()
                self.dy = -JUMP_VELOCITY
                self.animation = self.animations['jumping']
                self.state = 'jumping'
            elseif love.keyboard.isDown('down') then
                if love.keyboard.isDown('left') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['crouch_walking']
                    self.direction = 'left'
                    self.state = 'crouch_walking'
                elseif love.keyboard.isDown('right') then
                    self.dx = MOVE_SPEED
                    self.direction = 'right'
                    self.state = 'crouch_walking'
                    self.animation = self.animations['crouch_walking']
                else
                    self.dx = 0
                    self.state = 'crouch_idle'
                    self.animation = self.animations['crouch_idle']
                end
            elseif love.keyboard.isDown('right') then
                self.dx = MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'right'
                self.state = 'walking'
            else
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.dx = 0
            end

            self:checkUpCollision()
            self:checkRightCollision()
            self:checkLeftCollision()
        end,
        ['crouch_idle'] = function(dt)
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('down') then
                if love.keyboard.isDown('left') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['crouch_walking']
                    self.direction = 'left'
                    self.state = 'crouch_walking'
                elseif love.keyboard.isDown('right') then
                    self.dx = MOVE_SPEED
                    self.animation = self.animations['crouch_walking']
                    self.direction = 'right'
                    self.state = 'crouch_walking'
                else
                    self.dx = 0
                    self.state = 'crouch_idle'
                    self.animation = self.animations['crouch_idle']
                end
            else
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.dx = 0
            end
            self:checkUpCollision()
        end,
        ['crouch_walking'] = function(dt)
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('down') then
                if love.keyboard.isDown('left') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['crouch_walking']
                    self.direction = 'left'
                    self.state = 'crouch_walking'
                elseif love.keyboard.isDown('right') then
                    self.dx = MOVE_SPEED
                    self.direction = 'right'
                    self.state = 'crouch_walking'
                    self.animation = self.animations['crouch_walking']
                else
                    self.dx = 0
                    self.state = 'crouch_idle'
                    self.animation = self.animations['crouch_idle']
                end
            else
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.dx = 0
            end
            self:checkUpCollision()
        end,
        ['jumping'] = function(dt)
            -- break if we go below the surface
            if self.y > 300 then
                return
            end

            if love.keyboard.isDown('left') then
                self.direction = 'left'
                self.dx = -MOVE_SPEED
            elseif love.keyboard.isDown('right') then
                self.direction = 'right'
                self.dx = MOVE_SPEED
            end

            -- apply map's gravity before y velocity
            self.dy = self.dy + self.map.gravity

            self:checkUpCollision()

            -- check if there's a tile directly beneath us
            self:checkDownCollision()
            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end,
        ['hurt'] = function(dt)

            if love.keyboard.isDown('left') then
                self.dx = -MOVE_SPEED
                self.direction = 'left'
            elseif love.keyboard.isDown('right') then
                self.dx = MOVE_SPEED
                self.direction = 'right'
            else
                self.dx = 0
            end
            self.dy = self.dy + self.map.gravity
            self:checkDownCollision()
            self:checkLeftCollision()
            self:checkUpCollision()
            self:checkRightCollision()
        end,
        ['loss'] = function(dt)
            self.dy = self.dy + self.map.gravity
        end
    }
end

function Player2:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.behaviors[self.state](dt)
    self.currentFrame = self.animation:getCurrentFrame()

    if self.x + self.width >= VIRTUAL_WIDTH then
        self.dx = 0
        self.x = (self.map:tileAt(self.x, self.y).x * self.map.tileWidth) - self.width
    end

    if self.x <= 0 then
        self.dx = 0
        self.x = self.map:tileAt(self.x, self.y).x * self.map.tileWidth
    elseif self.y < 0 then
        self.dy = self.dy + self.map.gravity
        self.y = 0
    end

    if self.state ~= 'loss' then
        self:checkLoss()
    end

    self.animation:update(dt)
end

function Player2:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end

    if self.y > box.y + box.height or self.y +self.height < box.y then
        return false
    end

    if self.y > box.y then
        return true
    else
        return false
    end
end

function Player2:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

function Player2:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

function Player2:checkUpCollision()
    if self.dy < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x, self.y - 1)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dy = 0
            self.y = self.map:tileAt(self.x, self.y - 1).y * self.map.tileHeight
        end
    end
end

function Player2:checkLoss()
    if self.score == 0 then
        players = players - 1
        self.state = 'loss'
        self.animation = self.animations['loss']
    end
end

function Player2:reset()
    self.x = (map.mapWidth * map.tileWidth) - (map.mapWidth * map.tileWidth / 5)
    self.y = map.mapHeight * map.tileHeight / 2
    self.state = 'idle'
    self.animation = self.animations['idle']
    self.dy = 0
    self.score = 3
end

function Player2:checkDamage()
    if self.dy > 0 then
        if self.map:tileAt(self.x, self.y).id == LAVA_FLOOR or
            self.map:tileAt(self.x + self.width - 1, self.y).id == LAVA_FLOOR then
            -- reset y velocity
            sounds['Hurt']:play()
            self.state = 'hurt'
            self.animation = self.animations['hurt']
            self.dy = -JUMP_VELOCITY
            self.score = self.score - 1
        end
    elseif self.dx < 0 then
        if self.map:tileAt(self.x - 1, self.y).id == LAVA or
            self.map:tileAt(self.x - 1, self.y + self.height).id == LAVA then
            -- reset y velocity
            sounds['Hurt']:play()
            self.state = 'hurt'
            self.animation = self.animations['hurt']
            self.dx = HURT_VELOCITY
            self.score = self.score - 1
        end
    elseif self.dx > 0 then
        if self.map:tileAt(self.x + self.width - 1, self.y).id == LAVA or
            self.map:tileAt(self.x + self.width - 1, self.y + self.height).id == LAVA then
            -- reset y velocity
            sounds['Hurt']:play()
            self.state = 'hurt'
            self.animation = self.animations['hurt']
            self.dx = -HURT_VELOCITY
            self.score = self.score - 1
        end
    end
end

function Player2:checkDownCollision()
    if self.dy >= 0 then
        -- check if there's a tile directly beneath us
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
        
                -- if so, reset velocity and position and change state
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.y  = (self.map:tileAt(self.x, self.y).y - 1) * self.map.tileHeight
            end
    end
end

function Player2:render()
    local scaleX

    if self.direction == 'left' then
        scaleX = -1
    else
        scaleX = 1
    end

    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height - 9), 
        0, scaleX, 1, 
        self.width / 2, self.height / 2)

    if instructions == false then
        if self.score > 2 then
            love.graphics.draw(self.hearts, self.heart[1], (map.mapWidth * map.tileWidth) - (8 * map.tileWidth), map.tileHeight)
        else
            love.graphics.draw(self.hearts, self.heart[12], (map.mapWidth * map.tileWidth) - (8 * map.tileWidth), map.tileHeight)
        end

        if self.score > 1 then
            love.graphics.draw(self.hearts, self.heart[1], (map.mapWidth * map.tileWidth) - (10 * map.tileWidth), map.tileHeight)
        else
            love.graphics.draw(self.hearts, self.heart[12], (map.mapWidth * map.tileWidth) - (10 * map.tileWidth), map.tileHeight)
        end

        if self.score > 0 then
            love.graphics.draw(self.hearts, self.heart[1], (map.mapWidth * map.tileWidth) - (12 * map.tileWidth), map.tileHeight)
        else
            love.graphics.draw(self.hearts, self.heart[12], (map.mapWidth * map.tileWidth) - (12 * map.tileWidth), map.tileHeight)
        end
    end
end