--[[
    GD50
    Legend of Zelda

    Author: Olivia Maciejewska
    olma7987@colorado.edu
]]

--6.2 Carry pot walk state

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    local direction = self.player.direction

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    if direction == 'left' then
        hitboxWidth = 16
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 16
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 16
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 16
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerLiftState:enter(params)
    -- restart sword swing animation
    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)
    local potIndex
    local potCollision = false
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.liftHitbox) and object.solid then
            potCollision = true
            potIndex = k
        end
    end
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
           -- check if hitbox collides with pots
           --6.2 sets bool to lifted for selected pot
        if potCollision then
            self.dungeon.currentRoom.objects[potIndex].lifted = true
            self.player:changeState('carry-idle')
        else
            self.player:changeState('idle')
        end
    end

end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end