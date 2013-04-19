This is a main controller. It controlls `/`.

Learn [more about controllers](https://github.com/twilson63/creamer/tree/master/examples/mvc).

    module.exports = 
      "/":
        get: ->
          @bind "index", 