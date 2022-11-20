local Platform = require 'src.entities.platform'
local Heart = require 'src.entities.heart'
local Star = require 'src.entities.star'

local GameManager = class('GameManager')

local CAMERA_SPEEDS = {
	{mark = 0, speed = 60},
	{mark = 15, speed = 70},
	{mark = 30, speed = 85},
	{mark = 50, speed = 100},
	{mark = 90, speed = 115},
	{mark = 130, speed = 130},
	{mark = 175, speed = 150},
	{mark = 220, speed = 180},
	{mark = 270, speed = 210},
	{mark = 330, speed = 240},
	{mark = 400, speed = 275},

	{mark = math.huge, speed = 0}
}

local H_BORDER = 48

function GameManager:initialize()
	self.platforms = {}

	self.time = 0
	self.cameraSpeedIndex = 1

	self.score = 0

	self.hearts = {}
	self.lives = 2
	self.platformNumToSpawnHeart = 5
	self.platformNumPerHeart = 15
	self.platformNumToSpawnHeartVariability = 3

	self.stars = {}

	self:spawnPlatforms(-120)

	self.gameEnded = false
end

function GameManager:update(dt)
	-- Manage the camera
	GS.current().camera:move(0, CAMERA_SPEEDS[self.cameraSpeedIndex].speed * dt)

	self.time = self.time + dt
	if self.time >= CAMERA_SPEEDS[self.cameraSpeedIndex+1].mark then
		self.cameraSpeedIndex = self.cameraSpeedIndex + 1
	end


	-- Manage platforms
	self:manage(self.platforms)
		-- If the lowest platform is in the screen, spawn new platforms
	local lowestPlatform = self:getLowestPlatform(nil, true)
	local cameraX, cameraY = GS.current().camera:position()
	if lowestPlatform.y - cameraY < love.graphics.getWidth()/2 then
		self:spawnPlatforms()
	end

	-- Manage hearts
	self:manage(self.hearts)

	-- Manage stars
	self:manage(self.stars)

	-- Manage score
	self.score = self.score + 50 * dt

	if self.gameEnded then
		GS.switch(End, self.score)
	end
end

function GameManager:draw()
	for _, platform in pairs(self.platforms) do
		platform:draw()
	end
	for _, heart in pairs(self.hearts) do
		heart:draw()
	end
	for _, star in pairs(self.stars) do
		star:draw()
	end
end

function GameManager:manage(entities)
	for _, entity in pairs(entities) do
		entity:update(dt)
	end
	for key, entity in pairs(entities) do
		local cameraX, cameraY = GS.current().camera:position()
		if entity.y < cameraY - 260 then
			table.remove(entities, key)
			if GS.current().world:hasItem(entity.collider) then
				GS.current().world:remove(entity.collider)
			end
			break
		end
	end
end

function GameManager:getLowestPlatform(limitY, includeSpike)
	local limitY = limitY or math.huge
	local maxY, lowestPlatform = -math.huge, nil

	for _, platform in pairs(self.platforms) do
		if platform.y > maxY and platform.y < limitY then
			-- 4 outcome
				-- isSpiked & includeSpike
				-- not isSpiked & includeSpike
				-- isSpiked & not includeSpike <- remove this outcome
				-- not isSpiked & not includeSpike
			if not (platform.isSpiked == true and includeSpike == false) then
				lowestPlatform = platform
				maxY = platform.y
			end

		end
	end

	return lowestPlatform
end

function GameManager:spawnPlatforms(YOffsets)
	local YOffsets = YOffsets or 0
	local cameraX, cameraY = GS.current().camera:position()

	local i = math.random(1, 8)
	if i == 1 then -- Spawn 3 platforms continuously
		for i = 1, 3 do
			self:spawn('platform', 1,
					cameraY + love.graphics.getHeight()/2 + 70 * (i+1) + YOffsets)
		end

	elseif i == 2 then -- Spawn 2 normal platforms and 1 spike platform
		self:spawn('platform', 1,
				cameraY + love.graphics.getHeight()/2 + 75 * 2 + YOffsets)
		self:spawn('platform', 1,
				cameraY + love.graphics.getHeight()/2 + 75 * 2 + YOffsets)
		self:spawn('spike', 1,
				cameraY + love.graphics.getHeight()/2 + 75 * 4 + YOffsets)

	elseif i == 3 or i == 4 then -- Spawn 4 platforms, 2 of which are at the same Y
		self:spawn('platform', 1,
				cameraY + love.graphics.getHeight()/2 + 80 * 2 + YOffsets)
		self:spawn('platform', 1,
				cameraY + love.graphics.getHeight()/2 + 80 * 3 + YOffsets)
		self:spawn('platform', 2,
				cameraY + love.graphics.getHeight()/2 + 80 * 4 + YOffsets)

	elseif i == 5 or i == 6 then -- Spawn 3 platforms, 2 of which are at the same Y, and 1 spike
		self:spawn('platform', 2,
				cameraY + love.graphics.getHeight()/2 + 80 * 2 + YOffsets)
		self:spawn('spike', 1,
				cameraY + love.graphics.getHeight()/2 + 80 * 3 + YOffsets)

	elseif i == 7 or i == 8 then -- Spawn 3 platforms and 2 spike which are at the same Y
		self:spawn('platform', 1,
				cameraY + love.graphics.getHeight()/2 + 80 * 2 + YOffsets)
		self:spawn('spike', 2,
				cameraY + love.graphics.getHeight()/2 + 80 * 3 + YOffsets)

	end
end

function GameManager:spawn(platformType, num, y)
	local isSpiked
	if platformType == 'platform' then
		isSpiked = false
	elseif platformType == 'spike' then
		isSpiked = true
	end


	for i = 1, num do
		local x = (H_BORDER + math.random() * (love.graphics.getWidth() - H_BORDER * 2)) / num +
				love.graphics.getWidth() / num * (i-1)
		local platform = Platform(x, y, isSpiked)
		table.insert(self.platforms, platform)

		-- Spawn random coins if not spike
		if not isSpiked then
			-- Spawning hearts
			self.platformNumToSpawnHeart = self.platformNumToSpawnHeart - 1
			if self.platformNumToSpawnHeart <= 0 then
				self.platformNumToSpawnHeart = self.platformNumPerHeart +
						math.random(
							-self.platformNumToSpawnHeartVariability,
							self.platformNumToSpawnHeartVariability
						)
				local heart = Heart(x, y - 26)
				table.insert(self.hearts, heart)

			else
				-- Spawning stars
				local i = math.random(1, 10)
				if i == 1 or i == 2 or i == 3 then -- Too bad

				elseif i == 4 then -- 2 stars
					self:spawnStars(x, y,
							-12, -26, 12, -26)
				elseif i == 5 then -- 3 stars
					self:spawnStars(x, y,
							-18, -26, 0, -26, 18, -26)
				elseif i == 6 then -- 4 stars
					self:spawnStars(x, y,
							-30, -26, -10, -26, 10, -26, 30, -26)
				elseif i == 7 then -- 6 stars
					self:spawnStars(x, y,
							-18, -24, 0, -24, 18, -24, -18, -36, 0, -36, 18, -36)
				elseif i == 8 then -- 3 stars triangle
					self:spawnStars(x, y,
							-18, -26, 0, -40, 18, -26)
				elseif i == 9 then -- 4 stars isosceles trapezium
					self:spawnStars(x, y,
							-30, -26, -10, -38, 10, -38, 30, -26)
				elseif i == 10 then -- 5 stars U shape
					self:spawnStars(x, y,
							-18, -38, -18, -26, 0, -38, 18, -38, 18, -26)
				end
			end
		end
	end
end

function GameManager:spawnStars(platformX, platformY, ...)
	local coords = {...}
	for i = 1, #coords, 2 do
		local star = Star(platformX + coords[i], platformY + coords[i+1])
		table.insert(self.stars, star)
	end
end


function GameManager:loseLife()
	self.lives = self.lives - 1
	print('lives : '..tostring(self.lives))

	if self.lives < 0 then
		self.gameEnded = true
	end
end

function GameManager:gainLife(heart)
	self.lives = self.lives + 1
	print('lives : '..tostring(self.lives))

	for k, heart_ in pairs(self.hearts) do
		if heart == heart_ then
			table.remove(self.hearts, k)
			if GS.current().world:hasItem(heart.collider) then
				GS.current().world:remove(heart.collider)
			end
		end
	end

	self.score = self.score + 300
end

function GameManager:earnStar(star)
	self.score = self.score + 50

	for k, star_ in pairs(self.stars) do
		if star == star_ then
			table.remove(self.stars, k)
			if GS.current().world:hasItem(star.collider) then
				GS.current().world:remove(star.collider)
			end
		end
	end
end


function GameManager:getPlatforms()
	return self.platforms
end

function GameManager:getCameraSpeed()
	return CAMERA_SPEEDS[self.cameraSpeedIndex].speed
end

return GameManager