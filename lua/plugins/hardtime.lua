return {
  {
    "m4xshen/hardtime.nvim",
    opts = {
      max_time = 1000,      -- Time threshold for considering key repeats
      max_count = 3,        -- Max allowed repeated key presses
      disable_mouse = true, -- Disables mouse support
      hint = true,          -- Enables hint messages
      notification = true,  -- Enables notification messages
    },
  },
}
