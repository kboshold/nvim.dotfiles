if true then return {} end
return {
  "karb94/neoscroll.nvim",
  config = function ()
    require('neoscroll').setup({})
  end
}
