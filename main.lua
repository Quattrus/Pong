function love.load()
    paddleWidth = 14
    paddleHeight = 120
    paddle1Speed = 150
    paddleSpeed = 150
    paddleX = (love.graphics.getWidth() - paddleWidth) - 15
    paddleY = love.graphics.getHeight() / 2
    paddle1X = 15
    paddle1Y = love.graphics.getHeight()/2
    ballRadius = 10
    ballPosX = love.graphics.getWidth()/2
    ballPosY = love.graphics.getHeight()/2
    direction = love.math.random(1, 2)
    state = "none"
    upDownState = "none"
    playerScore = 0
    enemyScore = 0
    playerWon = false
    playerLost = false
    ballSpeed = 1
    beep = love.audio.newSource("beep.mp3", "static")
    love.window.setTitle("Pong")
end

function love.update(dt)
    checkPlayerInput(dt)
    moveEnemyPaddle(dt)
    playerBounds()
    enemyPaddleBounds()
    ballBounds()
    serveBall()
    checkCollisions()
    ballStates()
    scoreCheck()
    gameOverCheck()
end

function love.draw()
    if playerWon == false and playerLost == false then
    love.graphics.rectangle("fill", paddleX, paddleY, paddleWidth, paddleHeight)
    love.graphics.rectangle("fill", paddle1X, paddle1Y, paddleWidth, paddleHeight)
    love.graphics.circle("fill", ballPosX, ballPosY, ballRadius)
    love.graphics.print(playerScore, love.graphics.getWidth()/2 - 50, 120, 0, 5)
    love.graphics.print(enemyScore, love.graphics.getWidth()/2 + 50, 120, 0 , 5)
    elseif playerWon == true then
        love.graphics.print("You win!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 , 0, 5)
    elseif playerLost == true then
        love.graphics.print("You lost!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2, 0, 5)
    end
end

function gameOverCheck()
    if playerScore == 10 then
        playerWon = true
    elseif enemyScore == 10 then
        playerLost = true
    end
end

function scoreCheck()
    if ballPosX < paddle1X then
        enemyScore = enemyScore + 1
        ballPosX = love.graphics.getWidth() / 2
        ballPosY = love.graphics.getHeight() / 2
        state = "none"
        upDownState = "none"
        ballSpeed = 1
    elseif ballPosX > paddleX + paddleWidth then
        if playerScore <= 5 then
            paddleSpeed = paddleSpeed + 100
        elseif playerScore > 5 then
            paddleSpeed = paddleSpeed + 50
        end
        playerScore = playerScore + 1
        ballPosX = love.graphics.getWidth()/2
        ballPosY = love.graphics.getHeight()/2
        state = "none"
        upDownState = "none"
        ballSpeed = 1
    end
end

function ballStates()
    if state == "moveLeft" then
        ballPosX = ballPosX - ballSpeed
    elseif state == "moveRight" then
    ballPosX = ballPosX + ballSpeed
    end

    if upDownState == "moveUp" then
        ballPosY = ballPosY - ballSpeed
    elseif upDownState == "moveDown" then
        ballPosY = ballPosY + ballSpeed
    end
end

function serveBall()
    if state == "none" and randomDirection() == "left" then
        state = "moveLeft"
    elseif state == "none" and randomDirection() == "right" then
        state = "moveRight"
    end
end

function checkCollisions()
    if state == "moveLeft" and (ballPosX - ballRadius > paddle1X) and (ballPosX - ballRadius <= paddle1X + paddleWidth) and (ballPosY - ballRadius < paddle1Y + paddleHeight) and (ballPosY + ballRadius > paddle1Y) then
        state = "moveRight"
        beep:play()
        ballSpeed = ballSpeed + love.math.random(1,3)
        if ballPosY - ballRadius >= paddle1Y and ballPosY + ballRadius <= paddle1Y + 40 then
            upDownState = "moveUp"
        elseif ballPosY + ballRadius <= paddle1Y + paddleHeight and ballPosY - ballRadius >= paddle1Y + 80 then
            upDownState = "moveDown"
        else
            upDownState = "none"
        end
    end
    if state == "moveRight" and (ballRadius + ballPosX >= paddleX) and (ballPosX + ballRadius < paddleX + paddleWidth) and (ballPosY - ballRadius < paddleY + paddleHeight) and (ballPosY + ballRadius > paddleY) then
        state = "moveLeft"
        ballSpeed = ballSpeed + love.math.random(0.2,1)
        beep:play()
        if ballPosY - ballRadius >= paddleY and ballPosY + ballRadius <= paddleY + 40 then
            upDownState = "moveUp"
        elseif ballPosY + ballRadius <= paddleY + paddleHeight and ballPosY - ballRadius >= paddleY + 80 then
            upDownState = "moveDown"
        else
            upDownState = "none"
        end
    end
end

function checkPlayerInput(dt)
    if love.keyboard.isDown("w") then
        paddle1Y = paddle1Y - paddle1Speed * dt
    elseif love.keyboard.isDown("s") then
    paddle1Y = paddle1Y + paddle1Speed * dt
end
end

function moveEnemyPaddle(dt)
    if ballPosY < paddleY then
        paddleY = paddleY - paddleSpeed * dt
    elseif ballPosY > paddleY + paddleHeight then
        paddleY = paddleY + paddleSpeed * dt
    end
end

function playerBounds()
    if paddle1Y < 0 then
        paddle1Y = 0
    elseif (paddle1Y + paddleHeight) > love.graphics.getHeight() then
        paddle1Y = love.graphics.getHeight() - paddleHeight
    end
end

function enemyPaddleBounds()
    if paddleY < 0 then
        paddleY = 0
    elseif paddleY + paddleHeight > love.graphics.getHeight() then
        paddleY = love.graphics.getHeight() - paddleHeight
    end
end

function ballBounds()
    if ballPosY - ballRadius <= 0 then
        upDownState = "moveDown"
    elseif ballPosY  + ballRadius >= love.graphics.getHeight() then
        upDownState = "moveUp"
    end
end

function randomDirection()
    if direction == 1 then
        return "left"
    elseif direction == 2 then
        return "right"
    end
end