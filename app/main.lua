local lor = require("lor.index")
local session_middleware = require("lor.lib.middleware.session")
local router = require("app.router")
local whitelist = require("app.config.config").whitelist
local app = lor()

app:conf("view engine", "tmpl")
app:conf("view ext", "html")
app:conf("views", "./app/views")

app:use(session_middleware())

-- filter: add response header
app:use(function(req, res, next)
    res:setHeader('X-Powered-By', 'Lor Framework')
    next()
end)

-- intercepter: login or not
app:use(function(req, res, next)
	local requestPath = req.path
    local inWhitelist = false
    for i, v in ipairs(whitelist) do
        if requestPath == v then
            inWhitelist = true
        end
    end

    if inWhitelist then
        next()
    else
        if req.session and req.session.username then
            next()
        else
            res:redirect("/auth/login")
        end
    end
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