local lor = require("lor.index")
local userRouter = lor:Router() -- 生成一个router对象


-- 按id查找用户
userRouter:get("/query/:id", function(req, res, next)
    local query_id = req.params.id -- 从req.params取参数
    res:json({
        id = query_id,
        desc = "this if from user router"
    })
end)

-- 删除用户
userRouter:post("/delete/:id", function(req, res, next)
    local id = req.params.id
    res:json({
        id = id,
        desc = "delete user " .. id
    })
end)


return userRouter

