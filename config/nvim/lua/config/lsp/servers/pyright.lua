local util = require("lspconfig.util")

return {
  root_dir = function(fname)
    return util.root_pattern("pyrightconfig.json")(fname)
      or util.find_git_ancestor(fname)
      or util.path.dirname(fname)
  end
}
