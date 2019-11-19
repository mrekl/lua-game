function newEnemy(x, y, direction, power)
    local ret = {}

    ret.posX = x
    ret.posY = y
    ret.direction = direction

    ret.width = 32
    ret.height = 38

    math.randomseed(os.time())
    ret.speed = math.random(50, 250)

    ret.power = power

    ret.shotsNumb = 1
    ret.shots = {}

    ret.enemyImg = love.graphics.newImage('src/img/enemy.png')

    function ret:show()
        if self.direction ~= 'destructed' then
            -- love.graphics.rectangle('fill', self.posX, self.posY, self.width, self.height)
            love.graphics.draw(self.enemyImg, self.posX, self.posY)
            love.graphics.print(self.power, self.posX + self.width, self.posY)
        end
    end

    function ret:move(dt)
        if self.direction ~= 'destructed' then
            if self.power > 0 then
                if self.posX <= self.width / 2 then
                    self.direction = 'right'
                elseif self.posX >= settings.resolution.x - self.width - self.width / 2 then
                    self.direction = 'left'
                end

                if self.direction == 'left' then
                    self.posX = self.posX - self.speed * dt
                elseif self.direction == 'right' then
                    self.posX = self.posX + self.speed * dt
                end
            end
        end
    end

    function ret:fire()
        if self.direction ~= 'destructed' then
            math.randomseed(os.time())
            self.shots[self.shotsNumb] = newShot({posX = self.posX + self.width / 2 - 7.5, posY = self.posY + self.height}, 'enemy', math.random(1, 3))
            self.shotsNumb = self.shotsNumb + 1
        end
    end

    function ret:collision()
        if self.power > 1 then
            self.power = self.power - 1
            return nil
        else
            self:destruct()
            return 'destructed'
        end
    end

    function ret:destruct()
        self.posX = self.width
        self.posY = 0
        self.direction = 'destructed'
    end

    return ret
end