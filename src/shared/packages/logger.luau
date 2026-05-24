local logger = {}
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local game_name = MarketplaceService:GetProductInfoAsync(game.PlaceId).Name

function logger.start_session()
	HttpService:PostAsync(
		"http://127.0.0.1:5000/start",
		HttpService:JSONEncode({
			session = game.JobId,
			project = game_name
		}),
		Enum.HttpContentType.ApplicationJson
	)
end

-- channel = which log file to write to, e.g. "combat", "economy", "errors"
function logger.log(channel, msg)
	local data = {
		channel = channel,
		time = os.date("%X") .. string.format(".%03d", (os.clock() * 1000) % 1000),
		message = msg
	}
	HttpService:PostAsync(
		"http://127.0.0.1:5000/log",
		HttpService:JSONEncode(data),
		Enum.HttpContentType.ApplicationJson
	)
end

function logger.log_raw(channel, msg)
	HttpService:PostAsync(
		"http://127.0.0.1:5000/log_raw",
		HttpService:JSONEncode({ channel = channel, message = msg }),
		Enum.HttpContentType.ApplicationJson
	)
end

return logger