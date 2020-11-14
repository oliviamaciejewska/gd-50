--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- reference to player for collisions, etc.
    self.player = player

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = 1
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()

--6.2 generate a random number of pots up to 3
    local numberPots = math.random(3)
    for i = 1, numberPots do
        table.insert(self.objects, GameObject(
            GAME_OBJECT_DEFS['pot'],
            math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
		))
        local pot = self.objects[i]

         
    end

    -- get a reference to the switch
    --6.2 reference no longer 1 since pot was added
    local switch = GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
        )
    table.insert(self.objects, switch)

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'
            
            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then
            local heartChance = math.random(4)
        --6.1 get enemy location
            local xHeart = entity.x
            local yHeart = entity.y

            entity.dead = true

            --6.1 heart dropping from enemies
            -- entity.heartDropped boolean ensures enemy only drops heart once instead of continuously, as enemies are not removed as entities upon death
            
            if entity.heartDropped == false then
                if heartChance == 1 then
                    local heart = GameObject (
                    GAME_OBJECT_DEFS['heart'],
                    xHeart, yHeart)
                    heart.onConsume = function(player, heart)
                
                        if self.player.health == 5 then
                            self.player:healthHeart(1)
                        elseif self.player.health < 5 then
                            self.player:healthHeart(2)
                        end
                    end
			
                    table.insert(self.objects, heart)
                end
                entity.heartDropped = true
            end

        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
        for k, object in pairs(self.objects) do
        --6.3 enemy collision for pots
            if entity:collides(object) and object.lifted == false and object.thrown == false and object.solid == true then
                if entity.direction == 'left' then
                    entity.x = entity.x - PLAYER_WALK_SPEED * dt
                    if entity.x <= object.x + object.width then
                        entity.x = object.x + object.width  + 0.5
                    end
                elseif entity.direction == 'right' then
                    entity.x = entity.x + PLAYER_WALK_SPEED * dt
                    if entity.x + entity.width >= object.x then
                        entity.x = object.x - entity.width  - 1
                    end
                elseif entity.direction == 'up' then
                    entity.y = entity.y - PLAYER_WALK_SPEED * dt
                    if entity.y <= object.y + object.height - entity.height/2 then
                        entity.y = object.y + object.height - entity.height/2 + 0.8
                    end
                else
                    entity.y = entity.y +PLAYER_WALK_SPEED * dt
                    if entity.y + entity.height >= object.y then
                        entity.y = object.y - entity.height - 1
                    end
                end
            elseif entity:collides(object) and object.thrown == true then               
                entity:damage(1)
                gSounds['hit-enemy']:play()
                object.thrown = false
                object.destroyedPot = true
            end
        end

    end

    for k, object in pairs(self.objects) do
        object:update(dt)
        
        if object.lifted then
            object.x = self.player.x
            object.y = self.player.y - 10
        end
        if object.destroyedPot then
            --local potX = object.x
            --local potY = object.y
            table.remove(self.objects, k)
            --[[local brokenPot = GameObject (
                GAME_OBJECT_DEFS['pot'],
                potX, potY)
			
            table.insert(self.objects, brokenPot)]]
        end
        -- trigger collision callback on object
        if self.player:collides(object) then
        
        --6.1 if object is consummable (heart) then call onConsume, else call onCollide
            if self.player:collides(object) then
                if object.consummable == true then
                    object.onConsume(self.player)
                    table.remove(self.objects, k)

                --6.2 make pots solid so player cannot walk through. todo later: make it solid for all entities
                elseif object.solid == true and not object.thrown then
                    if self.player.direction == 'left' then
                        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
                        if self.player.x <= object.x + object.width then
                            self.player.x = object.x + object.width  + 0.5
                        end
                    elseif self.player.direction == 'right' then
                        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
                        if self.player.x + self.player.width >= object.x then
                            self.player.x = object.x - self.player.width  - 1
                        end
                    elseif self.player.direction == 'up' then
                        self.player.y = self.player.y - PLAYER_WALK_SPEED * dt
                        if self.player.y <= object.y + object.height - self.player.height/2 then
                            self.player.y = object.y + object.height - self.player.height/2 + 0.8
                        end
                    else
                        self.player.y = self.player.y +PLAYER_WALK_SPEED * dt
                        if self.player.y + self.player.height >= object.y then
                            self.player.y = object.y - self.player.height - 1
                        end
                    end
                else
                    object:onCollide()
                end
            end
        end
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        if not object.destroyedPot then object:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()
end