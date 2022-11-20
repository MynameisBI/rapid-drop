local Agent = {}


local sampleTileSize = 12

local chooseActionMode = 'explore'
local learningRate = 0.1


function Agent:initialize()
	--self.qTable = self:getQTable('qTable.json')
	self.qTable = self:getQTable()
end

function Agent:getQTable(from)
	if from == nil then
		local qTable = {}
		-- States
		--local screenWidth, screenHeight, objectTypeNum = 480, 420, 4
		-- Actions
		local actionNum = 3

		local stateId = 1
		local stateSpace = math.pow(objectTypeNum, stateWidth * stateHeight)
		::whileLoop::
			qTable[stateId] = {}
			for action = 1, actionNum do
				qTable[stateId][action] = 0
			end
			stateId = stateId + 1
		if stateId <= stateSpace then
			goto whileLoop
		end
		return qTable

	else
		local file = io.open(from, "r")
		local qTableString = file:read()
		file:close()

		local qTable = json.decode(qTableString)
		return qTable
	end
end

function Agent:saveQTable(as)
	local fileName = as or 'qTable.json'

	local qTableString = json.encode(self.qTable)

	local file = io.open(fileName, "w")
	file:write(qTableString)
	file:close()
end

function Agent:getAction(state)
	if chooseActionMode == 'explore' then
		return math.random(1, 3)
	elseif chooseActionMode == 'exploit' then

	end
end

function Agent:updateQTable(state, action, reward)

end

return Agent
