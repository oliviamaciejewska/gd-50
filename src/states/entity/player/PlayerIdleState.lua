--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

end


function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.entity:changeState('lift')
        
        --[[for i, object in pairs(self.dungeon.currentRoom.objects) do
            if object:collides(self.liftHitbox) then
                self.entity:changeState('carry-idle')
            end
        end]]
    end
    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end