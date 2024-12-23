WIDTH = 1280
HEIGHT = 720

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
end

paddle = {}
paddle.y = HEIGHT - 100
paddle.x = 10
paddle.w = 200
paddle.h = 20
paddle.speed = 400

ball = {}
ball.y = 100
ball.x = 100
ball.w = 15
ball.h = 15
ball.velocity = {}
ball.velocity.x = 160
ball.velocity.y = 160

function love.draw()
    love.graphics.setColor(.18,.67,.98)

    love.graphics.rectangle('fill',0,0,WIDTH, HEIGHT)

    love.graphics.reset()
    love.graphics.setColor(1,0.84,0)
    love.graphics.rectangle('fill', paddle.x, paddle.y, paddle.w, paddle.h)
    love.graphics.reset()


    love.graphics.setColor(1,0,0)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.w, ball.h)
end

function Collide(body, ball)
    if ball.h + ball.y > body.y and ball.x +ball.w > body.x and ball.x < body.x + body.w then
        
        ball.velocity.y = -ball.velocity.y
    end
end

function love.update(dt)

    ball.x = ball.x+ ball.velocity.x*dt
    ball.y = ball.y + ball.velocity.y*dt

   Collide(paddle, ball)

    if love.keyboard.isDown('d') and paddle.x + paddle.w < WIDTH  then
        paddle.x = paddle.x+ paddle.speed *dt       
    end

    
    if love.keyboard.isDown('a') and paddle.x > 0 then
        paddle.x = paddle.x- paddle.speed *dt       
    end
end
