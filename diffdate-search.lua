-- name = "Разность дат"
-- description = "Количество дней прошедших от (оставшихся до) заданной даты"
-- type = "search"
-- lang = "ru"
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
	    lin = "Осталось дней: " .. tostring(dt)
	    col = aio:colors().progress_good
	elseif dt < 0 then
	    lin = "Прошло дней: " .. tostring(-dt)
	    col = aio:colors().progress_bad
	else
	    lin = "Это сегодня"
	end
	search:show_lines({lin},{col})
end