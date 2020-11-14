--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    

    --6.2 if pot is lifted
    self.lifted = false

    --6.3 if pot is thrown
    self.thrown = false

    --6.3 if pot is now destroyed
    self.destroyedPot = false

    --6.3 direction for thrown object
    self.direction = nil
    --6.3 x and y tiles for thrown objects
    self.initialTileX = nil
    self.initialTileY = nil


    -- default empty collision callback
    self.onCollide = function() end

    --6.1 onConsume function for when heart is picked up (check if actually used)
    self.onConsume  = function() end

    --6.1 consummable def for heart (check if actually used)
    self.consummable = def.consummable
end

--6.2 collision function to check if hitbox collides with object
function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x +target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:update(dt)
    --6.3 adding velocity for thrown pot
    
    if self.thrown == true then
        --6.3 records initial tiles to ensure pot does not go further than 4 tiles away
        --once pot lands, it changes thrown to false in order to ensure it does not keep traveling
        if self.direction == 'left' then
            if self.initialTileX - self.x < TILE_SIZE * 4 and self.x > 0 then
                self.x = self.x - 60 * dt
                          
            else    
                self.thrown = false
                self.destroyedPot = true
            end
        elseif self.direction == 'right' then
            if self.x - self.initialTileX + self.width < TILE_SIZE * 4 and self.x < VIRTUAL_WIDTH then
                self.x = self.x + 60 * dt
            else              
                self.thrown = false
                self.destroyedPot = true
            end
        elseif self.direction == 'up' then
            if self.initialTileY - self.y < TILE_SIZE * 4 and self.y > 0 then
                self.y = self.y - 60 * dt
            
            else              
                self.thrown = false
                self.destroyedPot = true
            end
        elseif self.direction == 'down' then
            if self.y - self.initialTileY + self.height < TILE_SIZE * 4 and self.y < VIRTUAL_HEIGHT then
                self.y = self.y + 60 * dt
            else              
                self.thrown = false
                self.destroyedPot = true
            end
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end