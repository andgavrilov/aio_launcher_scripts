-- name = "Service"
-- description = "Service invisible widget"
-- type = "widget"
-- author = "Andrey Gavrilov"
-- version = "1.0"

function on_resume()
    ui:hide_widget()
    aio:do_action("fold")
    aio:fold_widget("tasks", false)
    --aio:fold_widget("calendarw", false)
    --[[local tab = aio:active_widgets()
    for i,v in ipairs(tab) do
        if v.name == "weather" or v.name == "calendarw" or v.name == "tasks" then
            aio:fold_widget(v.name, false)
        else
            aio:fold_widget(v.name, true)
        end
    end]]
    --aio:fold_widget("my-metawidget.lua", true)
end

--[[function on_widget_action(action, name)
    ui:show_toast(name.." "..action)
end]]

--[[function on_alarm()
    local tab = aio:available_widgets()
    local t = {}
    for k,v in pairs(tab) do
        table.insert(t,v.name)
    end
    local s = ""
    for i,v in ipairs(t) do
        s = s .. tostring(v)
        if i ~= #t then
            s = s .. ", "
        end
    end
    ui:show_toast(s)
end]]
