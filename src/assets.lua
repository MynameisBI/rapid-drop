local lg = love.graphics

Sprites = {
	heart = lg.newImage('assets/heart.png'),
	platform = lg.newImage('assets/platform.png'),
	spikePlatform = lg.newImage('assets/spikePlatform.png'),
	spikes = lg.newImage('assets/spikes.png'),
	star = lg.newImage('assets/star.png'),

	robot = {
		idle = lg.newImage('assets/robot/idle.png'),
		walk = lg.newImage('assets/robot/walk.png'),
		jump = lg.newImage('assets/robot/jump.png'),
	},
}