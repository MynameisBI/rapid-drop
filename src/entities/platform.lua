local Platform = class('Platform')

function Platform:initialize(x, y, isSpiked)
	self.x, self.y = x, y
	self.collider = Collider(self, 74, 18, function() return 'touch' end)

	self.isSpiked = isSpiked or false
	if isSpiked then
		self.sprite = Sprites.spikePlatform
	else
		self.sprite = Sprites.platform
	end
end

function Platform:update(dt)
end

function Platform:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1,
		self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

function Platform:flash()
	--local color
	--if self.isSpiked then
		--color = {0.9, 0.3, 0.9}
	--else
		--color = {0.3, 0.9, 0.9}
	--end
	--self.color = {1, 1, 1}
	--GS.current().timer:tween(0.5, self.color, {color[1], color[2], color[3]}, 'quad')
end

return Platform