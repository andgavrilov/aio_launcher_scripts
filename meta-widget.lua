-- name = "Meta widget"
-- type = "widget"
-- author = "Andrey Gavrilov"
-- version = "1.0"

prefs = require "prefs"
prefs._name = "metawidget"

widgets = {
    "text [TEXT]",
    "battery",
    "notes [NUM]",
    "exchange [NUM] [FROM] [TO]",
    "worldclock [TIME_ZONE]",
    "calendar [NUM]",
    "bitcoin",
    "traffic",
    "alarm",
    "tasks [NUM]",
    "memory",
    "storage",
    "weather [NUM]",
    "notify [NUM]",
    "screen",
    "dialogs [NUM]",
    "player",
    "health",
    "space [NUM]"
}

table.sort(widgets)

function on_resume()
    if not prefs.metawidget then
        prefs.metawidget = {"text Metawidget"}
    end
    redraw()
end

function on_settings()
    dialog_id = "settings"
    ui:show_radio_dialog("Select action", {"Add widget", "Remove widget", "Move widget", "Edit widget", "Edit metawidget"})
end

function on_dialog_action(res)
    local tab = prefs.metawidget
    if dialog_id == "settings" then
        if res == 1 then
            dialog_id = "add"
            ui:show_radio_dialog("Add widget", widgets)
        elseif res == 2 then
            dialog_id = "remove"
            ui:show_radio_dialog("Remove widget", tab)
        elseif res == 3 then
            dialog_id = "move"
            ui:show_radio_dialog("Move widget", tab)
        elseif res == 4 then
            dialog_id = "edit"
            ui:show_radio_dialog("Edit widget", tab)
        elseif res == 5 then
            dialog_id = "metaedit"
            ui:show_rich_editor({text = "{\n\"" .. table.concat(tab, "\",\n\"") .. "\",\n}", new = true})
        else
            dialog_id = ""
        end
    elseif dialog_id == "add" then
        dialog_id = ""
        if res ~= -1 then
            add_widget(res)
        end
    elseif dialog_id == "remove" then
        dialog_id = ""
        if res ~= -1 then
            remove_widget(res)
        end
    elseif dialog_id == "move" then
        if res == -1 then
            dialog_id = ""
        else
            dialog_id = "move_line"
            pos = res
            ui:show_radio_dialog("Remove widget", {"Up", "Down"})
        end
    elseif dialog_id == "edit" then
        if res == -1 then
            dialog_id = ""
        else
            dialog_id = "edit_line"
            pos = res
            ui:show_edit_dialog("Edit widget", "", tab[res])
        end
    elseif dialog_id == "metaedit" then
        dialog_id = ""
        if res ~= -1 then
            edit_metawidget(res.text)
        end
    elseif dialog_id == "add_line" then
        dialog_id = ""
        if (res ~= -1) and (res ~= "") then
            add_line(res)
        end
    elseif dialog_id == "move_line" then
        dialog_id = ""
        if res ~= -1 then
            move_widget(res)
        end
    elseif dialog_id == "edit_line" then
        dialog_id = ""
        if res ~= -1 then
            if res == "" then
                remove_widget(pos)
            else
                edit_line(res)
            end
        end
    else
        return
    end
end

function add_widget(res)
    local lines = widgets[res]:split(" ")
    local line = lines[1]
    if line == widgets[res] then
        local tab = prefs.metawidget
        table.insert(tab, line)
        prefs.metawidget = tab
        redraw()
    else
        dialog_id = "add_line"
        ui:show_edit_dialog("Enter parameters" .. widgets[res]:replace(line, ""), widgets[res], line .. " ")
    end
end

function add_line(res)
    local tab = prefs.metawidget
    table.insert(tab, res)
    prefs.metawidget = tab
    redraw()
end

function remove_widget(res)
    local tab = prefs.metawidget
    table.remove(tab, res)
    prefs.metawidget = tab
    redraw()
end

function move_widget(res)
    local tab = prefs.metawidget
    if res == 1 then
        if pos == 1 then
            return
        else
            local line = tab[pos]
            tab[pos] = tab[pos - 1]
            tab[pos - 1] = line
        end
    else
        if pos == #tab then
            return
        else
            local line = tab[pos]
            tab[pos] = tab[pos + 1]
            tab[pos + 1] = line
        end
    end
    prefs.metawidget = tab
    redraw()
end

function edit_metawidget(res)
    local tab = load("return " .. res)()
    prefs.metawidget = tab
    redraw()
end

function edit_line(res)
    local tab = prefs.metawidget
    tab[pos] = res
    prefs.metawidget = tab
    redraw()
end

function redraw()
    ui:build(prefs.metawidget)
end
