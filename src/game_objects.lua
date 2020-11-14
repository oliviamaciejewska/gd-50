--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        consummable = false,
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    --6.2 pot game object def
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 16,
        width = 16,
        height = 16,
        solid = true,
        defaultState ='ground',
        consummable = false,
        states = {
            ['ground'] = {
                frame = 16     
			},
            ['broken'] = {
                frame = 54     
			}
        }
    },

    --6.1 heart game obejct def
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unconsummed',
        consummable = true,
        states = {
            ['unconsummed'] = {
                frame = 5     
			}
		}
            
	}
}