local lor = require("lor.index")
local testRouter = lor:Router() -- 生成一个router对象


-- 按id查找用户
testRouter:get("/hello", function(req, res, next)
    res:send("hello world!")
end)

return testRouter
