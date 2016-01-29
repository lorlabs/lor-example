local function isLogin(req)
    local login = false
    if req.session then
        local session_username =  req.session.get("username") 
        if session_username and session_username ~= "" then  
            login = true
        end
    end
    
    return login
end

local function checkLogin(whitelist)
	return function(req, res, next)
		local requestPath = req.path
	    local in_white_list = false
	    for i, v in ipairs(whitelist) do
	        if requestPath == v then
	            in_white_list = true
	        end
	    end

	    if in_white_list then
	        next()
	    else
	        if isLogin(req) then  
	            next()
	        else
	            res:redirect("/auth/login")
	        end
	    end
	end
end

return checkLogin

