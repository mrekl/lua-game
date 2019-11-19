function newPlayer(x, y, controls)
    local ret = {}

    ret.posX = x
    ret.posY = y

    ret.width = 32
    ret.height = 38

    ret.shotsNumb = 1
    ret.shots = {}

    ret.lives = 2
    ret.power = 9
    ret.points = 0

    ret.playerImg = love.graphics.newImage('src/img/player.png')

    function ret:show()
        love.graphics.draw(self.playerImg, self.posX, self.posY)
        self:showPoints()
        self:showPower()
        self:showLives()
    end

    function ret:showPoints()
        love.graphics.print('Points: ' .. self.points, 5, 5)
    end

    function ret:showPower()
        if self.power >= 6 then
           love.graphics.setColor(0, 1, 0)
        elseif self.power >= 3 and self.power < 6 then
            love.graphics.setColor(0, 1, 1)
        elseif self.power >= 0 and self.power < 3 then
            love.graphics.setColor(1, 0, 0)
        end

        for i=0, self.power do
            love.graphics.rectangle('fill', settings.resolution.x - 205 + 20 * i, 5, 20, 20)
        end

        love.graphics.setColor(1, 1, 1)
    end

    function ret:showLives()
        love.graphics.setColor(0.7, 0, 0.2)

        for i=0, self.lives do
            love.graphics.rectangle('fill', settings.resolution.x - 245 - 20 * i * 2, 5, 20, 20)
        end

        love.graphics.setColor(1, 1, 1)
    end

    function ret:move()
        if love.keyboard.isDown(controls.left) then
            for i=1,10 do
                if self.posX > 0 then
                    self.posX = self.posX - 1
                end
            end
        elseif love.keyboard.isDown(controls.right) then
            for i=1,10 do
                if self.posX <= settings.resolution.x - self.width then
                    self.posX = self.posX + 1
                end
            end
        elseif love.keyboard.isDown(controls.up) then
            for i=1,10 do
                if self.posY > settings.resolution.y - self.height * 8 then
                    self.posY = self.posY - 1
                end
            end
        elseif love.keyboard.isDown(controls.down) then
            for i=1,10 do
                if self.posY < settings.resolution.y - self.height - 8 then
                    self.posY = self.posY + 1
                end
            end
        end
    end

    function ret:getPossition()
        return {x = self.posX, y = self.posY}
    end

    function ret:fire()
        self.shots[self.shotsNumb] = newShot({posX = self.posX + self.width / 2 - 7.5, posY = self.posY}, 'player', 2)
        self.shotsNumb = self.shotsNumb + 1
    end

    function ret:collision()
        if self.power > 0 then
            self.power = self.power - 1
        else
            self.power = 9
            self.lives = self.lives - 1
        end
    end

    return ret
end