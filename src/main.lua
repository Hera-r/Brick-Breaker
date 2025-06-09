pad = {}

pad.x = 0
pad.y = 0
pad.width = 70
pad.height = 15
pad.speed = 0

brick = {}
brick.width = 50
brick.height = 15
brick.numb = 16


ball = {}
ball.x = 0
ball.y = 0
ball.rad = 10
ball.seg = 100
ball.touch = true
ball.speed_x = 0
ball.speed_y = 0

level = {}


function start_ball()
	ball.touch = true

	for line=1, 6 do
		local col = 1
		level[line] = {}
		for col=1, brick.numb do
			level[line][col] = 1
		end
	end
end 


function love.load()
	love.window.setTitle("Brick Breaker: HR")
	width = love.graphics.getWidth( )
	height = love.graphics.getHeight( )
	pad.x = (width / 2) - pad.width / 2
	pad.y = height - (pad.height + 5)
	pad.speed = 10
	
	brick.width = 50
	brick.height = 15

	ball.x = 400
	ball.y = 400
	ball.x = pad.x
	ball.y = pad.y + ball.rad - (pad.height/2) - ball.rad
	ball.speed_x = 400
	ball.speed_y = 400
	start_ball()

end


function love.update(dt)
	if (love.keyboard.isDown("d") and pad.x < width - pad.width) then
		pad.x = pad.x + pad.speed 
	end
	if (love.keyboard.isDown("a") and pad.x > 0) then
		pad.x = pad.x - pad.speed
	end

	if (love.keyboard.isDown("space") and ball.touch == true) then
		ball.touch = false
	end

	if (ball.x + ball.rad < 0) then
		ball.speed_x = -ball.speed_x
		ball.x = 0 + ball.rad
	end

	if (ball.x + ball.rad > width) then
		ball.speed_x = -ball.speed_x
		ball.x = width - ball.rad
	end

	if (ball.y < 0) then
		ball.speed_y = -ball.speed_y
		ball.y = 0 + ball.rad
	end

	if ball.touch == true then
		ball.x = pad.x + pad.width / 2
		ball.y = pad.y + ball.rad - (pad.height/2) - ball.rad
	else		
		ball.x = ball.x + dt * ball.speed_x
		ball.y = ball.y + dt * -ball.speed_y
	end

	if ball.y > height and ball.touch == false then
		ball.speed_x = 400
		ball.speed_y = 400
		ball.touch = true
	end

	local padLeft   = pad.x
	local padRight  = pad.x + pad.width
	local padTop    = pad.y
	local padBottom = pad.y + pad.height

	if ball.speed_y < 0 then
		local toucheX = ball.x + ball.rad > padLeft  and ball.x - ball.rad < padRight
		local toucheY = ball.y - ball.rad < padBottom and ball.y > padTop

		if toucheX and toucheY then
			ball.y = padTop - ball.rad
			ball.speed_y = -ball.speed_y
		end
	end

	for line = 1, 6 do
		for col = 1, brick.numb do
			if level[line][col] == 1 then
				local bx = (col - 1) * brick.width
				local by = (line - 1) * brick.height
				if  ball.x + ball.rad > bx and
					ball.x - ball.rad < bx + brick.width and
					ball.y + ball.rad > by and
					ball.y - ball.rad < by + brick.height
				then
					level[line][col] = 0
					ball.y = by + brick.height + ball.rad
					ball.speed_y = -ball.speed_y
					return
				end
			end
		end
	end

end


function love.draw()
	love.graphics.setColor(1, 0, 1)

	bx, by = 0,0
	for line = 1, 6 do
		bx = 0
		for col = 1, brick.numb do
			if (level[line][col] == 1) then
				tmp_l = line
				tmp_c = col
				love.graphics.rectangle("fill", bx + 1, by + 1, brick.width - 2, brick.height - 2)
			end
			bx = bx + brick.width
		end
		by = by + brick.height
	end

	love.graphics.setColor(0, 0.4, 0)
	love.graphics.rectangle("fill", pad.x, pad.y, pad.width, pad.height)
	love.graphics.setColor(1, 0, 0)
	love.graphics.circle("fill", ball.x, ball.y, 10, 100)
end


function love.keypressed(k)    
	if k == 'escape' then
		love.event.quit()
	end
end
