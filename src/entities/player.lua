local Player = class('Player')

local GRAVITY = 1150
local MAX_FALL_SPEED_RATIO = 1.8
local MAX_FALL_SPEED_BONUS = 175
local JUMP_FORCE = 300

local MOVE_SPEED_RATIO = 0.4
local MOVE_SPEED_BONUS = 175


function Player:initialize(x, y)
	self.x, self.y = x, y
	self.vy = 0

	self.collider = Collider(self, 16, 38,
			function(item, other)
				if other.isHeart or other.isStar then
					return 'cross'
				else
					return 'slide'
				end
			end)

	self.animator = Animator(self, 'idle')
	self.animator:addAnimation('idle', Sprites.robot.idle, 2, 18, 0.4)
	self.animator:addAnimation('walk', Sprites.robot.walk, 2, 18, 0.2)
	self.animator:addAnimation('jump', Sprites.robot.jump, 1, 20, 0.4)

	self.lastFrameVY = nil
	self.spriteSY = 1
end

function Player:update(dt)
	self:animate(dt)

	self:move(dt)

	local cameraX, cameraY = GS.current().camera:position()
	if math.abs(self.y - cameraY) > 190 then
		self:reset()
	end
end

function Player:draw()
	love.graphics.setColor(1, 1, 1)
	local rx, ry = math.floor(self.x), math.floor(self.y)

	local finalX, finalY = rx - self.x, ry - self.y

	self.animator:draw(finalX, finalY + 19, 0, 1, self.spriteSY, 0, 19)
end

function Player:keypressed(key)
end


function Player:move(dt)
	-- Verticle
	self.lastFrameVY = self.vy

	local x, y, cols, len = self.collider:check(
			self.x, self.y + 1,
			function(item, other)
				if other.entity.isSpiked == false then
					return 'cross'
				else
					return nil
				end
			end)
	if len == 0 then
		self.vy = self.vy + GRAVITY * dt

		local maxFallSpeed =
				GS.current().gameManager:getCameraSpeed() * MAX_FALL_SPEED_RATIO + MAX_FALL_SPEED_BONUS
		if self.vy > maxFallSpeed then
			self.vy = maxFallSpeed
		end

	elseif len > 0 then
		if love.keyboard.isDown('space') then
			self.vy = -JUMP_FORCE
		else
			self.vy = 0
		end
	end
	self.y = self.y + self.vy * dt


	-- Horizontal
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		self.x = self.x -
			(GS.current().gameManager:getCameraSpeed() * MOVE_SPEED_RATIO + MOVE_SPEED_BONUS) * dt
	end
	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.x = self.x +
			(GS.current().gameManager:getCameraSpeed() * MOVE_SPEED_RATIO + MOVE_SPEED_BONUS) * dt
	end
	if self.x < 10 then self.x = 10 end
	if self.x > love.graphics.getWidth() - 10 then
		self.x = love.graphics.getWidth() - 10
	end

	local x, y, cols, len = self.collider:resolvePhysics(self.x, self.y)
	if len > 0 then
		for i = 1, len do
			if cols[i].other.entity.isSpiked then
				local tx, ty = cols[i].touch.x, cols[i].touch.y
				if math.abs(tx - cols[i].other.entity.x) < cols[i].other.width/2 + self.collider.width/2 - 2 and
						ty < cols[i].other.entity.y then
					self:reset()
				else
					self.x, self.y = x, y
				end
			elseif cols[i].other.entity.isHeart then
				self:gainLife(cols[i].other.entity)
			elseif cols[i].other.entity.isStar then
				self:earnStar(cols[i].other.entity)
			else
				self.x, self.y = x, y
			end
		end
	else
		self.x, self.y = x, y
	end
end

function Player:animate(dt)
	self.animator:setCurrentState('idle')
	if self.vy ~= 0 then
		self.animator:setCurrentState('jump')
	elseif love.keyboard.isDown('left') or love.keyboard.isDown('a')
			or love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.animator:setCurrentState('walk')
	end

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		self.animator:setFlip(true)
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.animator:setFlip(false)
	end

	self.animator:update(dt)

	if self.lastFrameVY ~= nil then
		if self.vy == 0 and self.lastFrameVY ~= 0 then
			self.spriteSY = 0.72
			GS.current().timer:tween(0.12, self, {spriteSY = 1}, 'back')
		end
	end
end

function Player:reset()
	local cameraX, cameraY = GS.current().camera:position()
	local lowestPlatform =
			GS.current().gameManager:getLowestPlatform(cameraY + love.graphics.getHeight()/2 - 16, false)
	if lowestPlatform ~= nil then
		self:loseLife()

		lowestPlatform:flash()
		self.x = lowestPlatform.x
		self.y = lowestPlatform.y - 40
		self.collider:updatePhysics(self.x, self.y)

		self.vy = 0
	end
end

function Player:loseLife()
	GS.current().gameManager:loseLife()
end

function Player:gainLife(heart)
	GS.current().gameManager:gainLife(heart)
end

function Player:earnStar(star)
	GS.current().gameManager:earnStar(star)
end

return Player