PauseState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]


function PauseState:enter(params)
   self.bird = params.bird
   self.pipePairs = params.pipePairs
   self.timer = params.timer
   self.randomTimer = params.randomTimer
   self.score = params.score
   self.lastY = params.lastY
   self.x = VIRTUAL_WIDTH / 2 - 64
   self.y = VIRTUAL_HEIGHT / 2 - 64
end

function PauseState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            randomTimer = self.randomTimer,
            score = self.score,
            lastY = self.lastY
           })
    end
end

function PauseState:render()
    -- simply render the score to the middle of the screen
    sounds['music']:pause()
    --love.graphics.setFont(flappyFont)
    --love.graphics.printf('PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
    self.image = love.graphics.newImage('pause.png')
    love.graphics.draw(self.image, self.x, self.y)
end