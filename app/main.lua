local lor = require("lor.index")
local session_middleware = require("lor.lib.middleware.session")
local check_login_middleware = require("app.middleware.check_login")
local whitelist = require("app.config.config").whitelist
local router = require("app.router")


local app = lor()

app:conf("view engine", "tmpl")
app:conf("view ext", "html")
app:conf("views", "./app/views")

app:use(session_middleware())

-- filter: add response header
app:use(function(req, res, next)
    res:set_header('X-Powered-By', 'Lor Framework')
   
    next()
end)

-- intercepter: login or not
app:use(check_login_middleware(whitelist))

router(app) -- business routers and routes

-- 404 error
app:use(function(req, res, next)
    if req:is_found() ~= true then
        res:status(404):send("404! sorry, page not found.")
    end
end)

-- error handle middleware
app:erroruse(function(err, req, res, next)
	ngx.log(500, err)
    res:status(500):send("unknown error")
end)

app:run()