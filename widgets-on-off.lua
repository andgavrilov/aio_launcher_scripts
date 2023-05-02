-- name = "Widget Switcher"
-- description = "Turns screen widgets on and off when buttons are pressed"
-- type = "widget"
-- arguments_default = "15 16 26 28 29"
-- author = "Andrey Gavrilov"
-- version = "2.0"

prefs = require "prefs"
prefs._name = "widget-switcher"
prefs.widgets = (not prefs.widgets) and {} or prefs.widgets

local widgets = {"weather","weatheronly","clock","alarm","worldclock","monitor","traffic","player","apps","appbox","applist","contacts","notify","dialogs","dialer","timer","stopwatch","mail","notes","tasks","feed","telegram","twitter","calendar","calendarw","exchange","finance","bitcoin","control","recorder","calculator","empty","bluetooth","map","remote","health","my-calendar.lua"}
local icons = {"fa:user-clock","fa:sun-cloud","fa:clock","fa:alarm-clock","fa:business-time","fa:network-wired","fa:exchange","fa:play-circle","fa:robot","fa:th","fa:list","fa:address-card","fa:bell","fa:comment-alt-minus","fa:phone-alt","fa:chess-clock","fa:stopwatch","fa:at","fa:sticky-note","fa:calendar-check","fa:rss-square","fa:paper-plane","fa:dove","fa:calendar-lines","fa:calendar-week","fa:euro-sign","fa:chart-line","fa:coins","fa:wifi","fa:microphone-alt","fa:calculator-alt","fa:eraser","fa:head-side-headphones","fa:map-marked-alt","fa:user-tag","fa:heart","fa:calendar-days"}
local names = {"Clock & weather","Weather","Clock","Alarm","Worldclock","Monitor","Traffic","Player","Frequent apps","My apps","App list","Contacts","Notify","Dialogs","Dialer","Timer","Stopwatch","Mail","Notes","Tasks","Feed","Telegram","Twitter","Calendar","Weekly calendar","Exchange","Finance","Bitcoin","Control panel","Recorder","Calculator","Empty widget","Bluetooth","Map","User widget","Health","Monthly calendar"}
local pos = 0
local buttons,colors = {},{}
local color = ui:get_colors()

function on_alarm()
    ui:show_buttons(get_buttons())
end

function on_long_click(idx)
	system:vibrate(10)
	buttons,colors = get_buttons()
    pos = idx
	if idx == #buttons then
		return
	end
	local widgets = get_widgets()
	ui:show_context_menu({{"angle-left",""},{"ban",""},{"angle-right",""},{widgets.icon[prefs.widgets[idx]],widgets.name[prefs.widgets[idx]]}})
end

function on_click(idx)
	system:vibrate(10)
	buttons,colors = get_buttons()
	if idx == #buttons then
	    aio:do_action("flashlight")
	    return
	end
	local widgets = get_widgets()
	for i=1,#buttons-1 do
	    local widget = widgets.name[prefs.widgets[i]]
	    if i == idx and not aio:is_widget_added(widget) then
	        aio:add_widget(widget, get_pos())
	        aio:fold_widget(widget, false)
	    else
	        aio:remove_widget(widget)
	    end
	end
    on_alarm()
end

function on_dialog_action(data)
	if data == -1 then
		return
	end
	prefs.widgets = data
	on_alarm()
end

function on_settings()
	local widgets = get_widgets()
	ui:show_checkbox_dialog("Select widgets", widgets.label, prefs.widgets)
end

function get_buttons()
	buttons,colors = {},{}
	local widgets = get_widgets()
	for i,v in ipairs(prefs.widgets) do
		table.insert(buttons, "fa:" .. widgets.icon[i])
		table.insert(colors, widgets.enabled[i] and color.enabled_icon or color.disabled_icon)
	end
	table.insert(buttons, "fa:flashlight")
	table.insert(colors, color.disabled_icon)
	return buttons,colors
end

function move(x)
    local tab = prefs.widgets
    if (pos*x == -1) or (pos*x == #tab) then
        return
    end
    local cur = tab[pos]
    local next = tab[pos+x]
    tab[pos+x] = cur
    tab[pos] = next
    prefs.widgets = tab
    on_alarm()
end

function remove()
    local tab = prefs.widgets
    table.remove(tab,pos)
    prefs.widgets = tab
    on_alarm()
end

function on_context_menu_click(menu_idx)
    if menu_idx == 1 then
        move(-1)
    elseif menu_idx == 2 then
        remove()
    elseif menu_idx == 3 then
        move(1)
    end
end

function on_widget_action(action, name)
    on_alarm()
end

function get_pos()
	local name = aio:self_name()
	local tab = aio:active_widgets()
	for _,v in ipairs(tab) do
		if v.name == name then
			return v.position+1
		end
	end
	return 4
end

function on_command(str)
    if (str:sub(1,5) == "flash") and (str:sub(6) == "1") then
        colors[#colors] = color.enabled_icon
    else
        colors[#colors] = color.disabled_icon
    end
    ui:show_buttons(buttons,colors)
end

function get_widgets()
	local widgets = {}
	widgets.icon = {}
	widgets.name = {}
	widgets.label = {}
	widgets.enabled = {}
	for i,v in ipairs(aio:available_widgets()) do
		if v.type == "builtin" then
			table.insert(widgets.icon, v.icon)
			table.insert(widgets.name, v.name)
			table.insert(widgets.label, v.label)
			table.insert(widgets.enabled, v.enabled)
		end
	end
	return widgets
end

