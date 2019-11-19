player = require 'game/player'
shot = require 'game/shot'
enemy = require 'game/enemy'

function love.load()
    love.window.setMode(settings.resolution.x, settings.resolution.y, {fullscreen = settings.resolution.fullscreen, vsync = true})

    bgSoundTheme = love.audio.newSource("src/sound/theme.mp3", "static")
    bgSoundTheme:setVolume(0.3)
    bgSoundTheme:setLooping(true)
    bgSoundTheme:play()

    view = 'menu'
    
    player = newPlayer(settings.resolution.x / 2, settings.resolution.y - 64, {left = 'left', right = 'right', up = 'up', down = 'down'})

    timer = 10
    direction = 'right'

    enemies = {}
    enemiesShotTimer = {
        i = {0},
        time = {0}
    }

    i = 0

    suit.theme.color = {
        normal  = {bg = {1, 1, 1, 0.2}, fg = {0.9, 0.9, 0.9}},
        hovered = {bg = {1, 1, 1, 0.3}, fg = {0.9, 0.9, 0.9}},
        active  = {bg = {1, 1, 1, 0.3}, fg = {0.9, 0.9, 0.9}}
    }
end

function love.draw()

    if view == 'menu' then
        suit.draw()
        bgSoundTheme:pause()
    elseif view == 'settings' then
        suit.draw()
    elseif view == 'game' then
        bgSoundTheme:play()
        -- love.graphics.print(player:getPossition().x .. 'x' .. player:getPossition().y)
        -- love.graphics.print(table.getn(player.shots), 0, 16)
        -- love.graphics.print(i, 0, 32)
        -- love.graphics.print('Lives: ' .. player.lives, settings.resolution.x - 100, 16)
        -- love.graphics.print('Power: ' .. player.power, settings.resolution.x - 100, 32)
        -- love.graphics.print(enemiesShotTimer.time[1], 0, 48)

        for i=1, table.getn(enemies) do
            enemies[i]:show()
        end

        for i=1, table.getn(enemies) do
            for j=1, table.getn(enemies[i].shots) do
                enemies[i].shots[j]:show()
            end
        end

        player:show()

        for i=1, table.getn(player.shots) do
            player.shots[i]:show()
        end
    end
end

function love.update(dt)

    if view == 'menu' then
        love.mouse.setVisible(true)
        suit.layout:reset(100, settings.resolution.y / 2)
        suit.layout:padding(0, 7)

        startBtn = suit.Button('START', suit.layout:row(300, 30))
        settingsBtn = suit.Button('SETTINGS', suit.layout:row())
        exitBtn = suit.Button('EXIT', suit.layout:row())

        if startBtn.hit then
            view = 'game'
        elseif settingsBtn.hit then
            view = 'settings'
        elseif exitBtn.hit then
            love.event.quit();
        end
    elseif view == 'settings' then
        love.mouse.setVisible(true)
        suit.layout:reset(100, settings.resolution.y / 2)
        suit.layout:padding(0, 7)

        backBtn = suit.Button('Back', suit.layout:row(150, 30))
        saveBtn = suit.Button('Save', suit.layout:row())

        if backBtn.hit then
            view = 'menu'
        end
    elseif view == 'game' then
        love.mouse.setVisible(false)
        
        i = i + 1
        if i == timer then
            i = 0

            math.randomseed(os.time())
            
            if math.random(1, 2) == 1 then
                direction = 'left'
            elseif math.random(1, 2) == 2 then
                direction = 'right'
            end

            enemies[table.getn(enemies) + 1] = newEnemy(math.random(0, settings.resolution.x), math.random(0, settings.resolution.y / 4) + 25, direction, math.random(1, 4))
            enemiesShotTimer.time[table.getn(enemies) + 1] = math.random(10, 200)
            enemiesShotTimer.i[table.getn(enemies) + 1] = 0

            timer = math.random(100, 500)
        end

        for i=1, table.getn(enemies) do
            if enemiesShotTimer.i[i] then 
                enemiesShotTimer.i[i] = enemiesShotTimer.i[i] + 1
                if enemiesShotTimer.i[i] == enemiesShotTimer.time[i] then
                    enemiesShotTimer.i[i] = 0
                    math.randomseed(os.time())
                    enemiesShotTimer.time[i] = math.random(10, 200)
                    if enemies[i] then
                        enemies[i]:fire()
                    end
                end
            end
        end

        for i=1, table.getn(enemies) do
            enemies[i]:move(dt)

            for j=1, table.getn(enemies[i].shots) do
                enemies[i].shots[j]:move(dt)
            end

            for j=1, table.getn(enemies[i].shots) do
                if enemies[i].shots[j]:collisionDetect(player.posX, player.posY, player.width, player.height) == true then
                    player:collision()
                    enemies[i].shots[j]:destruct()
                end
            end
        end

        player:move()

        for i=1, table.getn(player.shots) do
            player.shots[i]:move(dt)

            for j=0, table.getn(player.shots) do
                if enemies[j] then
                    if player.shots[i]:collisionDetect(enemies[j].posX, enemies[j].posY, enemies[j].width, enemies[j].height) == true then
                        if enemies[j]:collision() == 'destructed' then
                            player.points = player.points + 10
                        else
                            player.points = player.points + 1
                        end

                        player.shots[i]:destruct()                
                    end
                end
            end
        end
    end
end

function love.keypressed(key)
    if key == 'space' then
        player:fire()
    elseif key == 'escape' then
        if view == 'game' then
            view = 'menu'
        else
            view = 'game'
        end
    end
end