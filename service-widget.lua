-- name = "Service"
-- description = "Service invisible widget"
-- type = "widget"
-- author = "Andrey Gavrilov"
-- version = "1.0"

function on_resume()
    ui:hide_widget()
    aio:do_action("fold")
    aio:fold_widget("tasks", false)
end
