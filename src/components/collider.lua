local Collider = class('Collider')

function Collider:initialize(entity, w, h, filter, x, y)
	self.entity = entity

	self.width, self.height = w, h
	self.x, self.y = x or 0, y or 0
	self.filter = filter

	GS.current().world:add(self, entity.x - w/2 + self.x, entity.y - h/2 + self.y, w, h)
end

function Collider:resolvePhysics(x, y)
	local ax, ay, cols, len = GS.current().world:move(self,
			x - self.width/2 + self.x, y - self.height/2 + self.y, self.filter)
	return ax + self.width/2 - self.x, ay + self.height/2 - self.y, cols, len
end

function Collider:updatePhysics(x, y)
	GS.current().world:update(self, x - self.width/2 + self.x, y - self.height/2 + self.y)
end

function Collider:check(x, y, filter)
	local filter = filter or self.filter
	local ax, ay, cols, len = GS.current().world:check(self,
			x - self.width/2 + self.x, y - self.height/2 + self.y, filter)
	return ax + self.width/2 - self.x, ay + self.height/2 - self.y, cols, len
end

return Collider