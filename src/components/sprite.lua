local Sprite = class('Sprite')

function Sprite:initialize(entity, sprite, color, x, y, r, sx, sy)
	self.entity = entity

	self.sprite = sprite

	self.color = color or {1, 1, 1}

	self.x, self.y = x or 0, y or 0
	self.r, self.sx, self.sy = r, sx, sy
end

function Sprite:draw()
	love.graphics.setColor(self.color)
	love.graphics.draw(
		self.sprite, self.entity.x, self.entity.y,
		self.r, self.sx, self.sy,
		self.sprite:getWidth()/2 + self.x, self.sprite:getHeight()/2 + self.y
	)
end

return Sprite