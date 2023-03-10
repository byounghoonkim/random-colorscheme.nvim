local M = {}

M._current = 1

M.config = {
	random_on_startup = true,
	exclude_default_colorschems = true,
	colorschemes = nil,
	show_current = true,
}

local default_colorschemes = {
	"blue",
	"darkblue",
	"default",
	"delek",
	"desert",
	"elflord",
	"evening",
	"habamax",
	"industry",
	"koehler",
	"lunaperche",
	"morning",
	"murphy",
	"pablo",
	"peachpuff",
	"quiet",
	"ron",
	"shine",
	"slate",
	"torte",
	"zellner",
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("keep", opts or {}, M.config)

	if M.config.colorschemes then
	-- use user-defined colorschemes list
	else
		-- set colorschemes using installed list
		M.config.colorschemes = {}
		local colors = vim.fn.getcompletion("", "color")
		local function table_contains(tbl, x)
			local found = false
			for _, v in pairs(tbl) do
				if v == x then
					found = true
				end
			end
			return found
		end
		for _, value in ipairs(colors) do
			if M.config.exclude_default_colorschems and table_contains(default_colorschemes, value) then
			-- skip default colorscheme
			else
				table.insert(M.config.colorschemes, value)
			end
		end
	end

	vim.api.nvim_create_user_command("RandomColorscheme", function(opts)
		local rc = require("random-colorscheme")
		if opts.args == "next" then
			rc.Next()
		elseif opts.args == "prev" then
			rc.Prev()
		elseif opts.args == "list" then
			rc.List()
		else
			rc.Rand()
		end
	end, {
		nargs = 1,
		complete = function(ArgLead, CmdLine, CursorPos)
			return { "rand", "next", "prev", "list" }
		end,
	})

	if M.config.random_on_startup then
		M.Rand()
	end
end

M.List = function()
	for index, value in ipairs(M.config.colorschemes) do
		if index == M._current then
			print(value .. " (current)")
		else
			print(value)
		end
	end
end

M.Rand = function()
	local function random_number(limit)
		return ((os.time() % limit) + 1)
	end
	M._current = random_number(#M.config.colorschemes)
	pcall(vim.cmd.colorscheme, M.config.colorschemes[M._current])
	if M.config.show_current then
		print(vim.cmd.colorscheme())
	end
end

M.Next = function()
	if M._current >= #M.config.colorschemes then
		M._current = 1
	else
		M._current = M._current + 1
	end
	pcall(vim.cmd.colorscheme, M.config.colorschemes[M._current])
	if M.config.show_current then
		print(vim.cmd.colorscheme())
	end
end

M.Prev = function()
	if M._current <= 1 then
		M._current = #M.config.colorschemes
	else
		M._current = M._current - 1
	end
	pcall(vim.cmd.colorscheme, M.config.colorschemes[M._current])
	if M.config.show_current then
		print(vim.cmd.colorscheme())
	end
end

return M
