settings = {
    resolution = {
        x = 1240,
        y = 720,
        fullscreen = false
    }
}

function love.conf(t)
    t.title = "test"
    t.window.width = settings.resolution.x
    t.window.height = settings.resolution.y
    t.window.fullscreen = settings.resolution.fullscreen
end