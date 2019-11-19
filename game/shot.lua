function newShot(player, direction, speed)
    local ret = {}

    ret.posX = player.posX
    ret.posY = player.posY

    ret.direction = direction

    ret.width = 5
    ret.height = 5

    ret.speed = speed

    function ret:show()
        if self.direction == 'player' then
            love.graphics.setColor(1, 0, 0)
        elseif self.direction == 'enemy' then
            love.graphics.setColor(0.7, 0.2, 0.2)
        end
        
        if self.direction ~= 'destructed' then
            -- love.graphics.rectangle('fill', self.posX + self.width, self.posY - self.height * 2, self.width, self.height)
            love.graphics.circle('fill', self.posX + self.width * 1.5, self.posY - self.height * 2, self.width / 2)
            love.graphics.setColor(255, 255, 255)
        end
    end

    function ret:move(dt)
        if self.direction == 'player' and self.posY > 0 then
            self.posY = self.posY - self.height * dt * 50 * self.speed
        elseif self.direction == 'enemy' and self.posY < settings.resolution.y + self.height * 2 then
            self.posY = self.posY + self.height * dt * 50 * self.speed
        -- elseif self.direction == 'destructed' then
        --     self.posX = 1
        --     self.posY = 1
        end

        if self.posY < 0 or self.posY > settings.resolution.y + self.height * 2 then
            self.direction = 'destructed'
        end
    end

    function ret:collisionDetect(x, y, width, height)
        if self.posX >= x and self.posX <= x + width and self.posY >= y and self.posY <= y + height then
            return true
        else
            return false
        end
    end

    function ret:destruct()
        self.posX = 0
        self.posY = 0
        self.direction = 'destructed'
    end

    return ret
end