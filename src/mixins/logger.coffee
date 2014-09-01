# Copyright © 2014 All rights reserved
# Author: nhim175@gmail.com

ClassLogger =

  debug: () ->
    console.debug.apply console, @_build_msg(arguments)

  info: () ->
    console.info.apply console, @_build_msg(arguments)

  warn: () ->
    console.warn.apply console, @_build_msg(arguments)

  error: () ->
    console.error.apply console, @_build_msg(arguments)

  # private

  _build_msg: (txt) ->
    txt = Array.prototype.slice.call(txt, 0)
    if @logPrefix? then txt.splice 0, 0, "[#{@logPrefix}]"
    txt

module.exports = ClassLogger