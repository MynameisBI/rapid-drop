local Heart = class('Heart')

function Heart:initialize(x, y)
	self.x, self.y = x, y

	self.collider = Collider(self, 18, 18, function() return 'cross' end)
	self.isHeart = true

	self.sprite = Sprites.heart
end

function Heart:update(dt)
end

function Heart:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1,
			self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

return Heart