local M = {}

--- @param t table?
--- @return string?
M.encode = function(t)
  if t == nil then
    return nil
  end
  if vim.fn.has("nvim-0.9") and vim.json ~= nil then
    return vim.json.encode(t)
  else
    return require("fzfx.commons._json").encode(t)
  end
end

--- @param j string?
--- @return table?
M.decode = function(j)
  if j == nil then
    return nil
  end
  if vim.fn.has("nvim-0.9") and vim.json ~= nil then
    return vim.json.decode(j)
  else
    return require("fzfx.commons._json").decode(j)
  end
end

return M