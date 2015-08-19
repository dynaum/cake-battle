canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

bulletImg = nil
bullets = {}

cake = { x = 300, y = 400, speed = 200, img = nil }

function love.load()
  cake.img  = love.graphics.newImage('assets/cake.png')
  bulletImg = love.graphics.newImage('assets/coracao.png')

  love.graphics.setNewFont(12)
  love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('eventquit')
  end

  if love.keyboard.isDown("up", "w") then
    cake.y = cake.y - cake.speed * dt
  end
  if love.keyboard.isDown("down", "s") then
    cake.y = cake.y + cake.speed * dt
  end
  if love.keyboard.isDown("right", "d") then
    cake.x = cake.x + cake.speed * dt
  end
  if love.keyboard.isDown("left", "a") then
    cake.x = cake.x - cake.speed * dt
  end

  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot = true
  end

  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
    newBullet = { x = cake.x + (cake.img:getWidth()/2) - (bulletImg:getWidth()/2), y = cake.y, img = bulletImg }
    table.insert(bullets, newBullet)

    canShoot = false
    canShootTimer = canShootTimerMax
  end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end
end

function love.draw()
  love.graphics.draw(cake.img, cake.x, cake.y)

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
