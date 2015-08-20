canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

bulletImg = nil
bullets   = {}

cake = { x = 368, y = 520, speed = 200, img = nil }

createJellyTimerMax = 0.4
createJellyTimer = createJellyTimerMax

jellyImg = nil
jellies  = {}

isAlive = true
score = 0

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.load()
  cake.img  = love.graphics.newImage('assets/cake.png')
  bulletImg = love.graphics.newImage('assets/coracao.png')
  jellyImg  = love.graphics.newImage('assets/jelly.png')
  gunSound  = love.audio.newSource("assets/shoot.wav", "static")
  coinSound = love.audio.newSource("assets/coin.wav", "static")
  dieSound  = love.audio.newSource("assets/explosion.wav", "static")

  love.graphics.setNewFont(14)
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if love.keyboard.isDown("up", "w") and cake.y > 0 then
    cake.y = cake.y - cake.speed * dt
  end
  if love.keyboard.isDown("down", "s") and cake.y < (love.graphics.getHeight() - cake.img:getHeight()) then
    cake.y = cake.y + cake.speed * dt
  end
  if love.keyboard.isDown("right", "d") and cake.x < (love.graphics.getWidth() - cake.img:getWidth()) then
    cake.x = cake.x + cake.speed * dt
  end
  if love.keyboard.isDown("left", "a") and cake.x > 0 then
    cake.x = cake.x - cake.speed * dt
  end

  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 and isAlive then
    canShoot = true
  end

  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
    newBullet = { x = cake.x + (cake.img:getWidth()/2) - (bulletImg:getWidth()/2), y = cake.y, img = bulletImg }
    table.insert(bullets, newBullet)

    gunSound:stop()
    gunSound:play()
    canShoot = false
    canShootTimer = canShootTimerMax
  end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end

  createJellyTimer = createJellyTimer - (1 * dt)

  if createJellyTimer < 0 then
    createJellyTimer = createJellyTimerMax

    randomNumber = math.random(10, love.graphics.getWidth() - 64)
    newJelly = { x = randomNumber, y = -10, img = jellyImg }
    table.insert(jellies, newJelly)
  end

  for i, jelly in ipairs(jellies) do
    jelly.y = jelly.y + (150 * dt)

    if jelly.y > 544 then
      table.remove(jellies, i)
    end
  end

  for i, jelly in ipairs(jellies) do
    for b, bullet in ipairs(bullets) do
      if CheckCollision(jelly.x, jelly.y, jelly.img:getWidth(), jelly.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, b)
        table.remove(jellies, i)

        coinSound:play()
        score = score + 1
      end
    end

    if CheckCollision(jelly.x, jelly.y, jelly.img:getWidth(), jelly.img:getHeight(), cake.x, cake.y, cake.img:getWidth(), cake.img:getHeight()) 
      and isAlive then
      table.remove(jellies, i)

      dieSound:play()
      isAlive  = false
      canShoot = false
    end
  end

  if not isAlive and love.keyboard.isDown('r') then
    bullets = {}
    jellies = {}

    canShootTimer = canShootTimerMax
    createJellyTimer = createJellyTimerMax

    cake.x = 368
    cake.y = 520

    score = 0
    isAlive = true
  end
end

function love.draw()
  if isAlive then
    love.graphics.draw(cake.img, cake.x, cake.y)
  else
    love.graphics.print("Press 'R' to restart", love.graphics:getWidth() / 2 - 50, love.graphics:getHeight() / 2 - 10)
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end

  for i, jelly in ipairs(jellies) do
    love.graphics.draw(jelly.img, jelly.x, jelly.y)
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
