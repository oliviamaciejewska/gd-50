--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(player, dungeon)

    self.player = player
    self.dungeon = dungeon
    local direction = self.player.direction


end

function Projectile:update(dt)
    for i, object in pairs(self.dungeon.currentRoom.objects) do
        if object.lifted then
            object.lifted = false
            if direction == 'left' then
                while object.x > player.x - 32 do
                    object.x = object.x - self.player.walkSpeed * dt
                end
            elseif self.entity.direction == 'right' then
                while object.x < player.x + 32 do
                    self.entity.x = self.entity.x + self.entity.walkSpeed * dt
                end
            elseif self.entity.direction == 'up' then
                while object.y > player.y -32 do
                    self.entity.y = self.entity.y - self.entity.walkSpeed * dt
                end
            elseif self.entity.direction == 'down' then
                while object.y < player.y + 32 do
                    self.entity.y = self.entity.y + self.entity.walkSpeed * dt
                end
            end
        end
       
    end
end

function Projectile:render()

end