local Game = {}

Player = require 'src.entities.player'
GameManager = require 'src.entities.gameManager'

function Game:enter()
	love.graphics.setBackgroundColor(57/255, 52/255, 87/255)

	self.world = bump.newWorld(32)
	self.toBeRemoveColliders = {}

	self.timer = Timer.new()

	self.camera = Camera()

	self.player = Player(love.graphics.getWidth()/2, 20)
	self.gameManager = GameManager()
end

function Game:update(dt)
	if not love.keyboard.isDown('escape') then
		self.timer:update(dt)

		for _, collider in pairs(self.toBeRemoveColliders) do
			if self.world:hasItem(collider) then
				self.world:remove(collider)
			end
		end
		self.toBeRemoveColliders = {}

		self.player:update(dt)
		self.gameManager:update(dt)
	end
end

function Game:draw()
	self.camera:attach()

	self.player:draw()
	self.gameManager:draw()

	--local items = self.world:getItems()
	--love.graphics.setColor(1, 1, 1)
	--for i, item in pairs(items) do
		--local x, y, w, h = self.world:getRect(item)
		--love.graphics.rectangle('line', x, y, w, h)
	--end

	self.camera:detach()

	love.graphics.setColor(1, 1, 1)

	love.graphics.draw(Sprites.spikes, 0, 0)
	love.graphics.draw(Sprites.spikes, 0, love.graphics.getHeight(), 0, 1, -1)

	love.graphics.print(tostring(math.floor(self.player.x)))
	love.graphics.print(tostring(math.floor(self.player.y)), 0, 14)

	love.graphics.print('score : '..tostring(math.floor(self.gameManager.score)), 80)
end

function Game:keypressed(key)
	self.player:keypressed(key)
end

return Game