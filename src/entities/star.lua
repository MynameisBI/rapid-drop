local Star = class('Star')

function Star:initialize(x, y)
	self.x, self.y = x, y

	self.collider = Collider(self, 10, 16, function() return 'cross' end)
	self.isStar = true

	self.sprite = Sprites.star
end

function Star:update(dt)
end

function Star:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1,
			self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

return Star