local lor = require("lor.index")
local router = require("app.router")
local app = lor()

app:conf("view engine", "tmpl")
app:conf("view ext", "html")
app:conf("views", "./app/views")

app:use(function(req, res, next)
    -- 插件，在处理业务route之前的插件，可作编码解析、过滤等操作
    next()
end)


router(app) -- 业务路由处理


-- 404 error
app:use(function(req, res, next)
    if req:isFound() ~= true then
        res:status(404):send("sorry, not found.")
    end
end)


-- 错误处理插件
app:erroruse(function(err, req, res, next)
    res:status(500):send(err)
end)

app:run()

