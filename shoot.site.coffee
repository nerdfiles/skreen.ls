fs        = require('fs')
utils     = require('utils')
#cache    = require('./cache')
#mimetype = require('mimetype')

siteRunner = () ->
  casper = require('casper').create {
    verbose        : true
    logLevel       : 'debug'
    waitTimeout    : 10000
    stepTimeout    : 10000
    retryTimeout   : 150
    #clientScripts : ["jquery.min.js"]
    viewportSize:
      width  : 1176
      height : 806
    pageSettings:
      loadImages         : true
      loadPlugins        : true
      userAgent          : 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv: 22.0) Gecko/20100101 Firefox/22.0'
      webSecurityEnabled : false
      ignoreSslErrors    : true
    onWaitTimeout: () ->
      @echo('wait timeout')
      @clear()
      @page.stop()
    onStepTimeout: (timeout, step) ->
      @echo('step timeout')
      @clear()
      @page.stop()
  }

  # print out all the messages in the headless browser context
  casper.on('remote.message', (msg) ->
    @echo('remote message caught: ' + msg)
  )

  # print out all the messages in the headless browser context
  casper.on('page.error', (msg, trace) ->
     this.echo('Error: ' + msg, 'ERROR')
     for i in trace
       step = trace[i]
       @echo('   ' + step.file + ' (line ' + step.line + ')', 'ERROR')
  )

  filename = undefined
  links = []

  process.argv.forEach((arg, index) ->
    if index == 2
      filename = arg
    if index > 2
      links.push arg
  )
  x = pageName = _pageName = undefined
  i = -1
  casper.start "#{filename}/", ->
    # now x is an array of links
    x = links
    return

  casper.then ->
    @each x, ->
      ++i
      @thenOpen ("#{filename}" + x[i]), ->
        @capture @getTitle().replace(/\|/g, '-') + '.png'
        return
      return
    return

  casper.run()

siteRunner()
