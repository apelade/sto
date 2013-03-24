# props to: https://gist.github.com/FGRibreau/3135914

module.exports = 
  found: (name) ->
    try
      require(name)
    catch err
      if(err.code == 'MODULE_NOT_FOUND')
        return false
    return true
