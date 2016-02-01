local pairs = pairs
local ipairs = ipairs
local tremove = table.remove
local tinsert = table.insert
local lor = require("lor.index")
local todos = require("app.model.todo")
local todoRuter = lor:Router()


-- TODO:

-- cause error route to mathc /find/all
-- todoRuter:get("/all", function(req, res, next)
--     res:json(todos)
-- end)

-- PUT DELETE


todoRuter:post("/complete", function(req, res, next)
	local id = req.body.id
	local completed = req.body.completed
	if completed == "true" then
		completed = true
	else
		completed = false
	end

	for i, v in ipairs(todos) do
		if v.id == id then
			v.completed = completed
		end
	end

    res:json({
		success = true,
		msg = "mark successful"
	})
end)

todoRuter:put("/add", function(req, res, next)
	local id = req.body.id
	local title = req.body.title
	local completed = req.body.completed
	if completed == "true" then
		completed = true
	else
		completed = false
	end

	tinsert(todos, {
		id = id,
		title = title, 
		completed = completed
	})

    res:json({
		success = true,
		msg = "add successful"
	})
end)

todoRuter:post("/update", function(req, res, next)
	local id = req.body.id
	local title = req.body.title

	for i, v in ipairs(todos) do
		if v.id == id then
			v.title = title
		end
	end

    res:json({
		success = true,
		msg = "update successful"
	})
end)

todoRuter:delete("/delete", function(req, res, next)
	local id = req.body.todoId

 	for i=#todos, 1, -1 do 
        if todos[i].id == id then 
            table.remove(todos,i) 
        end 
    end 

    res:json({
		success = true,
		msg = "delete successful",
		data = {
			deleteId = id,
			todosLength = #todos,
			todos = todos
		}
	})
end)

todoRuter:get("/find/:filter", function(req, res, next)
	local todo_type = req.params.filter
	local return_todos = {}

	if todo_type ~= "all" and todo_type ~= "active" and todo_type ~= "completed" then
		res:json({
			success = false,
			msg = "wrong todo type, type must be one of 'all', 'active' or 'completed'"
		})
	else
		for i, v in ipairs(todos) do
			local completed = v.completed
			if todo_type == "all" then
				tinsert(return_todos, v)
			elseif todo_type == "active" and not completed then
				tinsert(return_todos, v)
			elseif todo_type == "completed" and completed then
				tinsert(return_todos, v)
			end
		end

	    res:json({
			success = true,
			msg = "",
			data = return_todos
		})
	end
end)


todoRuter:get("/index", function(req, res, next)
    local data = {
        username =  req.session.get("username")
    }
    res:render("todo", data)
end)


return todoRuter