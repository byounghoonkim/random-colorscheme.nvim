local M = {}

M._current = 1
M._colors = {}

function M.setup(opts)
	local colors = vim.fn.getcompletion("", "color")
	local default_colors = {
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
		if table_contains(default_colors, value) then
		-- skip default colorscheme
		else
			table.insert(M._colors, value)
		end
	end

	M.Rand()
end

M.Rand = function()
	local function random_number(limit)
		return ((os.time() % limit) + 1)
	end
	M._current = random_number(#M._colors)
	pcall(vim.cmd.colorscheme, M._colors[M._current])
end

M.Next = function()
	if M._current >= #M._colors then
		M._current = 1
	else
		M._current = M._current + 1
	end
	pcall(vim.cmd.colorscheme, M._colors[M._current])
end

M.Prev = function()
	if M._current <= 1 then
		M._current = #M._colors
	else
		M._current = M._current - 1
	end
	pcall(vim.cmd.colorscheme, M._colors[M._current])
end

return M
