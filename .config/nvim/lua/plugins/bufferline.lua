return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<Tab>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
  },
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = false,
      always_show_bufferline = true,
      get_element_icon = function(element)
        local icon = require("nvim-web-devicons").get_icon(element.path, element.extension, { default = true })
        return icon  -- no hl returned, icon inherits tab fg
      end,
    },
    highlights = {
      fill = {
        bg = "#001419",
      },
      background = {
        fg = "#576d74",
        bg = "#063540",
      },
      tab = {
        fg = "#576d74",
        bg = "#063540",
      },
      tab_selected = {
        fg = "#fdf5e2",
        bg = "#b28500",
        bold = true,
      },
      buffer_selected = {
        fg = "#fdf5e2",
        bg = "#b28500",
        bold = true,
      },
      indicator_selected = {
        fg = "#b28500",
        bg = "#b28500",
      },
      tab_separator = {
        fg = "#001419",
        bg = "#063540",
      },
      tab_separator_selected = {
        fg = "#001419",
        bg = "#b28500",
      },
      tab_close = {
        fg = "#576d74",
        bg = "#001419",
      },
      separator = {
        fg = "#001419",
        bg = "#063540",
      },
      separator_selected = {
        fg = "#001419",
        bg = "#b28500",
      },
    },
  },
}
