return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        confirm = function(picker, item)
          picker:close()
          if item then
            vim.cmd("tabedit " .. vim.fn.fnameescape(item.file or item.text or ""))
          end
        end,
      },
    },
  },
}
