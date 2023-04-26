-- name = "Date difference"
-- description = "Number of days passed since (remain until) the specified date in the format dd.mm.yyyy"
-- type = "search"
-- author = "Andrey Gavrilov"
-- version = "1.0"

function on_search(input)
	local date = input:match("(%d?%d%.%d?%d%.%d%d%d%d)")
	if not date then
		return
	end
	local d,m,y = date:match("(%d+)%.(%d+)%.(%d+)")
	local t1 = os.time{day=d,month=m,year=y}
	date = os.date("%d.%m.%Y")
	d,m,y = date:match("(%d+)%.(%d+)%.(%d+)")
	local t2 = os.time{day=d,month=m,year=y}
	local dt = os.difftime(t1,t2)/60/60/24
	local lin = ""
	local col = aio:colors().progress
	if dt > 0 then
	    lin = "Remaining days: " .. tostring(dt)
	    col = aio:colors().progress_good
	elseif dt < 0 then
	    lin = "Past days: " .. tostring(-dt)
	    col = aio:colors().progress_bad
	else
	    lin = "Today"
	end
	search:show_lines({lin},{col})
end