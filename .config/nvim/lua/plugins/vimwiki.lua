return {
  {
    "vimwiki/vimwiki",
    event = "VeryLazy",
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/vimwiki/",
          path_html = "~/vimwiki/html/",
          syntax = "default",
          ext = ".wiki",
        },
      }
      vim.g.vimwiki_global_ext = 0
    end,
  },
}
