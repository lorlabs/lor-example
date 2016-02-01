local authRouter = require("app.routes.auth")
local todoRouter = require("app.routes.todo")
local errorRouter = require("app.routes.error")

return function(app)

    app:use("/auth", authRouter())
    app:use("/todo", todoRouter())
    app:use("/error", errorRouter())


    app:get("/", function(req, res, next)
        if req.session and req.session.get("username") then
            res:redirect("/todo/index")
        else
            res:redirect("/auth/login")
        end
    end)

  
    app:get("/view", function(req, res, next)
        local data = {
            name =  req.query.name or "lor",
            desc =   req.query.desc or 'a framework of lua based on OpenResty'
        }
        res:render("login", data)
    end)

end

