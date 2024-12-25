WIDTH = 1280
HEIGHT = 720
LIVES = 3
SCORE = 0

bricks = {
    love.graphics.newImage('/images/Brick1.png'),
    love.graphics.newImage('/images/Brick2.png'),
    love.graphics.newImage('/images/Brick3.png')
}

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    state = "menu"
    background = love.graphics.newImage('/images/background1.png')
    
end

paddle = {}
paddle.img = love.graphics.newImage('/images/Paddle.png')
paddle.y = HEIGHT - 100
paddle.x = 10
paddle.w = paddle.img:getWidth()
paddle.h = paddle.img:getHeight()
paddle.speed = 400

ball = {}
ball.y = 100
ball.x = 100
ball.w = 15
ball.h = 15
ball.velocity = {}
ball.velocity.x = 160
ball.velocity.y = -160


AllBricks = {}

function BrickGenerator(x, y, lvl)
    local brick = {}

    brick.img = bricks[lvl]
    brick.w = brick.img:getWidth()
    brick.h = brick.img:getHeight()
    brick.x = x
    brick.y = y
    brick.lvl = lvl


    return brick
end

function levelMaker()
    local padding = 100
    local spacing = 20
    local cols = math.floor((WIDTH - padding * 2) / (64 + spacing))
    local rows = 3
    local startX = padding
    local startY = padding

    for i = 1, rows do
        lvl = love.math.random(1, 3)
        for j = 1, cols do
            if (i + j) % 2 == 0 then
                table.insert(AllBricks, BrickGenerator(startX + j * (64 + spacing), startY + i * (32 + spacing), lvl))
            end
        end
    end
end

levelMaker()



function love.draw()
    love.graphics.draw(background, 0, 0, 0, 5, 5)

    if state == "menu" then
        love.graphics.setColor(0,0,0)

        love.graphics.print("Press W to start playing",WIDTH/2 - 200, HEIGHT/2,0,3)
        love.graphics.reset()
    end
    if state == "play" or state == "serve" then
        love.graphics.draw(paddle.img, paddle.x, paddle.y)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Lives:"..tostring(LIVES),WIDTH-200,30,0,2,2)
        love.graphics.print("Score:"..tostring(SCORE),100,30,0,2,2)
love.graphics.reset()

love.graphics.setColor(1,0,0)
        love.graphics.rectangle('fill', ball.x, ball.y, ball.w, ball.h)
        love.graphics.reset()


        for k, v in pairs(AllBricks) do
            love.graphics.draw(v.img, v.x, v.y)
        end
    end
      if state == "over" then
        love.graphics.setColor(0,0,0)
        love.graphics.print("Game Over",WIDTH/2 - 200, HEIGHT/2,0,3)
        love.graphics.print("Score:"..tostring(SCORE),WIDTH/2 - 200, 40+HEIGHT/2,0,3)
        love.graphics.print("Press R to restart",WIDTH/2 - 200, 80+HEIGHT/2,0,3)
        love.graphics.reset()

        
    end
  
end

function Collide(body, target)
    if body.x + body.w > target.x and
        body.y + body.h > target.y and
        body.y < target.y + target.h and
        body.x < target.x + target.w then
        return true
    else
        return false
    end
end

function CollideBoundary(ball)
    if ball.x < 0 or ball.x + ball.w > WIDTH then
        ball.velocity.x = -ball.velocity.x
    end

    if ball.x < 0 then
        ball.x = 0
    end


    if ball.x > WIDTH then
        ball.x = WIDTH - ball.w
    end

    if ball.y < 0 then
        ball.velocity.y = -ball.velocity.y
        ball.y = 0
    end
end

function CollideBrick(ball, brick)
    if ball.y < brick.y + brick.h and ball.x + ball.w > brick.x and ball.x < brick.x + brick.w and ball.y + ball.h < brick.y then
        ball.velocity.y = -ball.velocity.y
    end
end

function love.keypressed(key)
    if key == "space" and state == "serve" then
        state = "play"
    end

    if key == "w" and state == "menu" then
        state = "serve"
    end
    if key == "r" and state == "over" then 
        state = "serve"
        LIVES = 3
        SCORE = 0
    end
end

function love.update(dt)
    for k, v in pairs(AllBricks) do
        love.graphics.draw(v.img, v.x, v.y)
    end
    if(LIVES == 0) then
        state = "over"
    end
    if (state == "play") then
        ball.x = ball.x + ball.velocity.x * dt
        ball.y = ball.y + ball.velocity.y * dt

        if(ball.y > HEIGHT) then
            state ="serve"
            LIVES = LIVES -1
        end

        if Collide(paddle, ball) then
            ball.velocity.y = -ball.velocity.y
            ball.y = paddle.y - ball.h
        end

        CollideBoundary(ball)

        for k, brick in pairs(AllBricks) do
            if Collide(brick, ball) then
                brick.lvl = brick.lvl - 1
                SCORE  = SCORE + 1
                if (brick.lvl > 0) then
                    brick.img = bricks[math.abs(brick.lvl)]
                end

                if ball.x + 4 > brick.x + brick.w then
                    ball.velocity.x = -ball.velocity.x
                    ball.x = brick.x + brick.w
                end
                if ball.x + ball.w - 4 < brick.x then
                    ball.velocity.x = -ball.velocity.x
                    ball.x = brick.x - ball.w
                end
                if ball.y + ball.h - 2 < brick.y then
                    ball.velocity.y = -ball.velocity.y
                    ball.y = brick.y - ball.h
                end
                if ball.y + 2 > brick.y + brick.h then
                    ball.velocity.y = -ball.velocity.y
                    ball.y = brick.y + brick.h
                end
            end
            if (brick.lvl == 0) then
                table.remove(AllBricks, k)
            end
        end
    end


    if state == "serve" then
        ball.x = paddle.x + paddle.w / 2 - ball.w / 2
        ball.y = paddle.y - ball.h
    end

    if love.keyboard.isDown('d') and paddle.x + paddle.w < WIDTH then
        paddle.x = paddle.x + paddle.speed * dt
    end

    if love.keyboard.isDown('a') and paddle.x > 0 then
        paddle.x = paddle.x - paddle.speed * dt
    end
end
