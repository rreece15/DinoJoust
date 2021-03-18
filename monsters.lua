monsters = Class{}

require 'Animation'
require 'Player'

function monsters:init(map)

    self.x = 50

    player = self.player

    self.width = 22
    self.height = 22

    self.blueTexture = love.graphics.newImage('sheets/blue.png')
    self.blueFrames = generateQuads(self.blueTexture, self.width, self.height)
    self.blueY = 40

    self.greenTexture = love.graphics.newImage('sheets/green.png')
    self.greenFrames = generateQuads(self.greenTexture, self.width, self.height)
    self.greenY = 80

    self.redTexture = love.graphics.newImage('sheets/red.png')
    self.redFrames = generateQuads(self.redTexture, self.width, self.height)
    self.redY = 120

    self.yellowTexture = love.graphics.newImage('sheets/yellow.png')
    self.yellowFrames = generateQuads(self.yellowTexture, self.width, self.height)
    self.yellowY = 160

    self.animations = {
        ['blue_off'] = Animation {
            texture = self.blueTexture,
            frames = {
                self.blueFrames[1]
            }, 
            interval = 1
        },
        ['green_off'] = Animation {
            texture = self.greenTexture,
            frames = {
                self.greenFrames[1]
            }, 
            interval = 1
        },
        ['red_off'] = Animation {
            texture = self.redTexture,
            frames = {
                self.redFrames[1]
            }, 
            interval = 1
        },
        ['yellow_off'] = Animation {
            texture = self.yellowTexture,
            frames = {
                self.yellowFrames[1]
            }, 
            interval = 1
        },
        ['blue_on'] = Animation {
            texture = self.blueTexture,
            frames = {
                self.blueFrames[23]
            }, 
            interval = 1
        },
        ['green_on'] = Animation {
            texture = self.greenTexture,
            frames = {
                self.greenFrames[23]
            }, 
            interval = 1
        },
        ['red_on'] = Animation {
            texture = self.redTexture,
            frames = {
                self.redFrames[23]
            }, 
            interval = 1
        },
        ['yellow_on'] = Animation {
            texture = self.yellowTexture,
            frames = {
                self.yellowFrames[23]
            }, 
            interval = 1
        }
    }

    self.animation = self.animations['blue_off']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviors = {
        ['blue_off'] = function(dt)
            self.animation = self.animations['blue_off']
        end,
        ['green_off'] = function(dt)
            self.animation = self.animations['green_off']
        end,
        ['red_off'] = function(dt)
            self.animation = self.animations['red_off']
        end,
        ['yellow_off'] = function(dt)
            self.animation = self.animations['yellow_off']
        end,
        ['blue_on'] = function(dt)
            self.animation = self.animations['blue_off']
        end,
        ['green_on'] = function(dt)
            self.animation = self.animations['green_off']
        end,
        ['red_on'] = function(dt)
            self.animation = self.animations['red_off']
        end,
        ['yellow_on'] = function(dt)
            self.animation = self.animations['yellow_off']
        end
        
    }
end

function monsters:update()
    --self.currentFrame = self.animation:getCurrentFrame()
end

function monsters:render()
    for x = 1, 4 do
        love.graphics.draw(self.blueTexture, self.blueFrames[1], self.x * x, self.blueY)
        love.graphics.draw(self.greenTexture, self.greenFrames[1], self.x * x, self.greenY)
        love.graphics.draw(self.redTexture, self.redFrames[1], self.x * x, self.redY)
        love.graphics.draw(self.yellowTexture, self.yellowFrames[1], self.x * x, self.yellowY)
    end
end