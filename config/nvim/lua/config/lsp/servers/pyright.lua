return {
  root_dir = function(fname)
    return vim.fs.root(fname, "pyrightconfig.json")
        or vim.fs.root(fname, ".git")
        or vim.fs.dirname(fname)
  end
}
