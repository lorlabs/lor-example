-- 业务路由管理
local userRouter = require("app.routes.user")
local testRouter = require("app.routes.test")

return function(app)

    -- group router, 对以`/user`开始的请求做过滤处理
    app:use("/user", userRouter())

    -- group router, 对以`/test`开始的请求做过滤处理
    app:use("/test", testRouter())

    -- 除使用group router外，也可单独进行路由处理，支持get/post/put/delete...

    -- welcome to lor!
    app:get("/", function(req, res, next)
        res:send("hi! welcome to lor framework.")
    end)

    -- hello world!
    app:get("/index", function(req, res, next)
        res:send("hello world!")
    end)

    -- render html, visit "/view" or "/view?name=foo&desc=bar
    app:get("/view", function(req, res, next)
        local data = {
            name =  req.query.name or "lor",
            desc =   req.query.desc or 'a framework of lua based on OpenResty'
        }
        res:render("index", data)
    end)
end

