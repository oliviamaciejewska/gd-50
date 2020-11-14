LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState)
    self.battleState = battleState

    local HP = self.battleState.player.party.pokemon[1].HP
    local attack = self.battleState.player.party.pokemon[1].baseAttack
    local defense = self.battleState.player.party.pokemon[1].baseDefense
    local speed = self.battleState.player.party.pokemon[1].baseSpeed


    self.battleState.player.party.pokemon[1]:levelUp()

    local newHP = self.battleState.player.party.pokemon[1].HP
    local newattack = self.battleState.player.party.pokemon[1].baseAttack
    local newdefense = self.battleState.player.party.pokemon[1].baseDefense
    local newspeed = self.battleState.player.party.pokemon[1].baseSpeed

    self.levelUpMenu =  Menu{
        x = VIRTUAL_WIDTH - 192,
        y = VIRTUAL_HEIGHT - 128,
        width = 192,
        height = 128,
        items = {
            {
                text = 'HP: ' .. tostring(HP) .. ' + ' .. tostring(newHP - HP) .. ' = ' ..tostring(newHP),
                onSelect = function()
                    -- pop battle menu
                    gStateStack:pop()
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 255, g = 255, b = 255
                        }, 1,
                        
                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state
                            --gStateStack:pop()

                            --pop levelup message
                            --gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 255, g = 255, b = 255
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            },
            {
                text = 'Attack: ' .. tostring(attack) .. ' + ' .. tostring(newattack - attack) .. ' = ' ..tostring(newattack)
            },
            {
                text = 'Defense: ' .. tostring(defense) .. ' + ' .. tostring(newdefense - defense) .. ' = ' ..tostring(newdefense)
            },
            {
                text = 'Speed: ' .. tostring(speed) .. ' + ' .. tostring(newspeed - speed) .. ' = ' ..tostring(newspeed)
            }
        },
        needCursor = false
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end