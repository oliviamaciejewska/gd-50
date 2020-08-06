Powerup = Class{}


function Powerup:init(def)
    self.width = 16
    self.height = 16

    self.x = math.random(16, VIRTUAL_WIDTH - 16)
    self.y = VIRTUAL_HEIGHT / 2 - 32
    self.dy = 0
    self.hasKey = def

    self.randP = math.random(1, 10)
    
    if self.hasKey == false then
        if self.randP < 3 then
            self.type = 7
        elseif self.randP > 2 then
            self.type = 10
        end
    else
        self.type = 7
    end

    self.inPlay = false
    self.ballsInPlay = false

end

function Powerup:collides(target)
    if self.x > target. x + target.width or target.x > self.x  + self.width then
        return false
    end

    if self.y > target.y + target. height or target.y > self.y + self. height then
        return false
    end

    if self.type == 10 then
        self.hasKey = true
    end

    return true
end

function Powerup:reset()
    self.inPlay = false
    self.x = math.random(16, VIRTUAL_WIDTH - 16)
    self.y = VIRTUAL_HEIGHT / 2 - 32
    self.dy = 0
    self.randP = math.random(1, 10)

    if self.hasKey == false then
        if self.randP < 3 then
            self.type = 7
        elseif self.randP > 2 then
            self.type = 10
        end
    else
        self.type = 7
    end

end
    

function Powerup:update(dt)
    if self.inPlay then
        self.y = self.y + self.dy * dt
    end
    
    self.randP = math.random(1, 10)
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type],
        self.x, self.y)
end