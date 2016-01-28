local authRouter = require("app.routes.auth")
local todoRouter = require("app.routes.todo")

return function(app)

    app:use("/auth", authRouter())
    app:use("/todo", todoRouter())


    app:get("/", function(req, res, next)
        if req.session and req.session.username then
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
        res:render("index", data)
    end)

end

