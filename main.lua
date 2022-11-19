require 'src.assets'
require 'src.globals'

-- Gamestates
Game = require 'src.gamestates.game'
Menu = require 'src.gamestates.menu'
Pause = require 'src.gamestates.pause'
End = require 'src.gamestates.end'

function love.load(...)
	love.keyboard.setKeyRepeat(true)

	GS.switch(Menu)
	GS.registerEvents()
end

function love.update(dt)

end

function love.draw()

end
