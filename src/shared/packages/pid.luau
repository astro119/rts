local pid = {}
pid.__index = pid

function pid.new(Kp, Ki, Kd)
	return setmetatable({
		Kp = Kp,
		Ki = Ki,
		Kd = Kd,
		integral = 0,
		previouserror = 0,
		derivative = 0, -- for low-pass filter
		output = 0,
		error = 0,
	}, pid)
end

function pid:update(error, deltaTime)
	local maxIntegral = 20
	local deadband = 0.1
	local decayThreshold = 0.05

	self.error = error
	-- Apply deadband: ignore tiny self.errors
	--if math.abs(self.error) < deadband then
	--	self.error = 0
	--end

	-- Accumulate integral with clamping
	--self.integral = self.integral + self.error * deltaTime
	self.integral = math.clamp(self.integral + self.error * deltaTime, -maxIntegral, maxIntegral)

	-- Decay integral when near the target
	if math.abs(self.error) < decayThreshold then
		self.integral = self.integral * 0.95 -- decay gradually
	end

	-- Derivative calculation with low-pass filter
	local rawDerivative = 0
	if deltaTime > 0 then
		rawDerivative = (self.error - self.previouserror) / deltaTime
	end

	local alpha = 0.5 -- smoothing factor
	self.derivative = alpha * rawDerivative + (1 - alpha) * self.derivative

	-- PID Output
	self.output = (self.Kp * self.error) + (self.Ki * self.integral) + (self.Kd * self.derivative)

	--print(self.Kp, self.Ki, self.Kd)
	self.previouserror = self.error
	return self.output
end

function pid:printResult()
	if self.output ~= nil then
		print(
			string.format("%.4f", self.output),
			"   ",
			string.format("%.4f", self.Kp * self.error),
			string.format("%.4f", self.Ki * self.integral),
			string.format("%.4f", self.Kd * self.derivative)
		)
	end
end

function pid:reset()
	self.integral = 0
	self.previouserror = 0
	self.derivative = 0
	self.error = 0
	self.output = 0
	--print("resetting pid")
end

return pid
