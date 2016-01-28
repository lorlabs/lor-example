local lor = require("lor.index")
local todoRuter = lor:Router()

todoRuter:get("/all", function(req, res, next)
    res:json({})
end)


todoRuter:get("/index", function(req, res, next)
    local data = {
        username =  req.session.get("username")
    }
    res:render("todo", data)
end)


return todoRuter
