local wezterm = require("wezterm")

-- Shamelessly stolen from <https://wezfurlong.org/wezterm/config/lua/PaneInformation.html>
function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local current_dir = basename(tab.active_pane.current_working_dir)

	local title = pane.pane_id .. ": " .. current_dir

	return {
		{ Text = " " .. title .. " " },
	}
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace() .. "  ")
end)

-- NOTE: `--` == '-' in Lua strings
is_macos = not not wezterm.target_triple:find("--apple--darwin$")

function test_nu_bin(bin)
	local succeeded = xpcall(function()
		wezterm.run_child_process({ bin, "-c", "exit" })
	end, function(err)
		print("failed to run `nu` binary (configged as `" .. bin .. "`):\n" .. err)
	end)
	return succeeded and bin or nil
end
local nu_bin = is_macos and test_nu_bin("/opt/homebrew/bin/nu") or test_nu_bin("nu")

font_size = is_macos and 17.0 or 13.0

return {
	colors = {
		foreground = "#CCCCCC",
		background = "#0C0C0C",

		cursor_bg = "#52ad70",
		cursor_fg = "black",
		cursor_border = "#52ad70",

		selection_fg = "black",
		selection_bg = "#FFFFFF",

		scrollbar_thumb = "#222222",

		split = "#444444",

		ansi = {
			"#0C0C0C",
			"#C50F1F",
			"#13A10E",
			"#C19C00",
			"#0037DA",
			"#881798",
			"#3A96DD",
			"#CCCCCC",
		},
		brights = {
			"#767676",
			"#E74856",
			"#16C60C",
			"#F9F1A5",
			"#3B78FF",
			"#B4009E",
			"#61D6D6",
			"#F2F2F2",
		},
		indexed = { [136] = "#af8700" },

		compose_cursor = "orange",

		copy_mode_active_highlight_bg = { Color = "#000000" },
		copy_mode_active_highlight_fg = { AnsiColor = "Black" },
		copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
		copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

		quick_select_label_bg = { Color = "peru" },
		quick_select_label_fg = { Color = "#ffffff" },

		quick_select_match_bg = { AnsiColor = "Navy" },
		quick_select_match_fg = { Color = "#ffffff" },
	},
	default_prog = nu_bin and { nu_bin, "-l" } or nil,
	font_size = font_size,
	-- Disable ligatures; I dun like 'em.
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	selection_word_boundary = " \t\n{}[]()\"'\\/`.,;:",
}
