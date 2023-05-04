-- name = "Widget Switcher"
-- description = "Turns screen widgets on and off when buttons are pressed"
-- type = "widget"
-- author = "Andrey Gavrilov"
-- version = "2.0"

prefs = require "prefs"
prefs._name = "widget-switcher"
prefs.widgets = (not prefs.widgets) and {} or prefs.widgets

local pos = 0
local color = ui:get_colors()
local buttons,colors = {},{}

function on_alarm()
    ui:show_buttons(get_buttons())
	system:su("settings get secure flashlight_enabled")
end

function on_long_click(idx)
	system:vibrate(10)
    pos = idx
	if idx > #prefs.widgets then
		return
	end
	local widgets = get_widgets()
	ui:show_context_menu({{"angle-left",""},{"ban",""},{"angle-right",""},{widgets.icon[prefs.widgets[idx]],widgets.label[prefs.widgets[idx]]}})
end

function on_click(idx)
	system:vibrate(10)
	if idx > #prefs.widgets then
	    aio:do_action("flashlight")
		system:su("settings get secure flashlight_enabled")
	    return
	end
	local widgets = get_widgets()
	for i,v in ipairs(prefs.widgets) do
	    local widget = widgets.name[v]
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
		table.insert(buttons, "fa:" .. widgets.icon[v])
		table.insert(colors, widgets.enabled[v] and color.enabled_icon or color.disabled_icon)
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
    tab[pos] = tab[pos+x]
    tab[pos+x] = cur
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

function on_shell_result(str)
    if str == "1" then
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
