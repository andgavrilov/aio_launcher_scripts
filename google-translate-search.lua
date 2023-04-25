-- name = "Google Translate"
-- description = "A search script that shows the translation of what you type in the search window"
-- data_source = "https://translate.google.com"
-- type = "search"
-- author = "Evgeny Zobnin"
-- version = "1.0"

local json = require "json"
local md_colors = require "md_colors"

-- constants
local blue = md_colors.blue_500
local red = md_colors.red_500
local uri = "http://translate.googleapis.com/translate_a/single?client=gtx&sl=auto"

-- vars
local text_from = ""
local text_to = ""

function on_search(input)
	text_from = input:match("^t (.+)")
	text_to = ""
	if text_from == nil then
		return
	end
	search:show_lines({"Translate \""..text_from.."\""}, {blue})
end

function on_click()
	if text_to == "" then
		search:show_lines({"Translating..."}, {blue})
		result = shttp:get(uri.."&tl="..system:get_lang().."&dt=t&q="..text_from)
		if result.error ~= nil then
			search:show_lines({result.error}, {red})
		else
			if result.code >= 200 and result.code < 300 then
				local t = json.decode(result.body)
				for i, v in ipairs(t[1]) do
					text_to = text_to..v[1]
				end
				local lang_from = t[3]
				if text_to ~= "" then
					search:show_lines({lang_from .. ": " .. text_to}, {blue})
				end
			else
				search:show_lines({"Server error"}, {red})
			end
		end
		return false
	else
		system:copy_to_clipboard(text_to)
	return true
	end
end
