local M = {}

function M.setup(opts)
	local colors = vim.fn.getcompletion("", "color")
	local temp_schemes = {}
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
			table.insert(temp_schemes, value)
		end
	end
	local function random_number(limit)
		return ((os.time() % limit) + 1)
	end
	pcall(vim.cmd.colorscheme, temp_schemes[random_number(#temp_schemes)])
end

return M
