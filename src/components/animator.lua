local Animator = class('Animator')

local newAnimation = function(spritesheet, frameNum, frameWidth, duration)
	local grid = anim8.newGrid(frameWidth, spritesheet:getHeight(),
			spritesheet:getWidth(), spritesheet:getHeight())
	return anim8.newAnimation(grid('1-'..tostring(frameNum), 1), duration)
end

function Animator:initialize(entity, currentState)
	self.entity = entity

	self.currentState = currentState

	self.animations = {}
	self.transitions = {}
	self.parameters = {}

	self.flipped = false
end

function Animator:addAnimation(state, spriteSheet, frameNum, frameWidth, duration)
	self.animations[state] = {
		spriteSheet = spriteSheet,
		frameNum = frameNum,
		frameWidth = frameWidth,
		animation = newAnimation(spriteSheet, frameNum, frameWidth, duration)
	}
end

function Animator:setFlip(isFlipped)
	if type(isFlipped) ~= 'boolean' then print('flip type is not boolean') end
	self.flipped = isFlipped
end

function Animator:setCurrentState(state)
	self.currentState = state
end

function Animator:update(dt)
	self.animations[self.currentState].animation:update(dt)
end

function Animator:draw(x, y, r, sx, sy, ox, oy)
	local x, y = x or 0, y or 0
	x, y = x + self.entity.x, y + self.entity.y

	local currentAnimation = self.animations[self.currentState]
	local ox = currentAnimation.spriteSheet:getWidth() / currentAnimation.frameNum / 2 + ox
	local oy = currentAnimation.spriteSheet:getHeight() / 2 + oy

	if not self.flipped then
		self.animations[self.currentState].animation:draw(
			self.animations[self.currentState].spriteSheet,
			x, y, r, sx, sy, ox, oy
		)
	else
		self.animations[self.currentState].animation:draw(
			self.animations[self.currentState].spriteSheet,
			x, y, r, -sx, sy, ox, oy
		)
	end
end

return Animator
