local wezterm = require("wezterm")

return {
	default_prog = { "nu", "-l" },
	font_size = 13.0,
	-- Disable ligatures; I dun like 'em.
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
}
