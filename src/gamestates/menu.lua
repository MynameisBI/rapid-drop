local Menu = {}

local WIDTH, HEIGHT = love.graphics.getDimensions()

function Menu:enter()
	self.suit = suit.new()

	self.currentFrame = 'main'

	self.loadCode = {text = ''}
end

function Menu:update(dt)
	if self.currentFrame == 'main' then
		if self.suit:Button('Play', WIDTH/2 - 60, 200, 120, 75).hit then
			GS.switch(Game)
		end


		--if self.suit:Button('Load game', 10, HEIGHT - 40, 75, 30).hit then
			--self.currentFrame = 'load'
		--end

	elseif self.currentFrame == 'load' then
		self.suit:Input(self.loadCode, 100, 210, 220, 30)
		if self.suit:Button('Copy', 325, 210, 30, 30).hit then
			love.system.setClipboardText(self.loadCode.text)
		end
		if self.suit:Button('Paste', 360, 210, 30, 30).hit then
			self.loadCode.text = love.system.getClipboardText()
		end
		if self.suit:Button('Back', 10, HEIGHT - 50, 80, 40).hit then
			self.currentFrame = 'main'
		end
	end
end

function Menu:draw()
	self.suit:draw()
end

function Menu:keypressed(key)
	self.suit:keypressed(key)
end

function Menu:textinput(t)
	self.suit:textinput(t)
end

function Menu:textedited(t, start, length)
	self.suit:textedited(t, start, length)
end

return Menu