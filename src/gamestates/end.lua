local End = {}

function End:enter(from, score)
	if score > highscore then
		highscore = score

		print('reach new high score')
	end
end

function End:update(dt)

end

function End:draw()

end

return End