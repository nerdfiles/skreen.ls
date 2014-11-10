
repo = undefined
base = '/Users/nerdfiles/Tools/screenshots/'
httpAddress = undefined
sys = require('sys')
exec = require('child_process').exec
#git  = require('gift')
puts = (error, stdout, stderr) -> sys.puts(stdout)

siteRunner = () ->
  #envVars = require('system').env

  #cache    = require('./cache')
  #mimetype = require('mimetype')
  fs = require('fs')
  process = require('process')
  #mkdirp = require('mkdirp')
  utils = require('utils')
  #utils.dump envVars
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
      webSecurityEnabled : true
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

  #require("utils").dump(casper.cli.args)
  argv = casper.cli.args

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

  filename = 'http://google.com'
  links = []

  if argv && argv.length > 0
    argv.forEach((arg, index) ->
      if index == 0
        filename = arg
      if index > 0
        links.push arg
    )

  filenameConstruct = filename.split('//')

  httpAddress = filenameConstruct[1]
  sep = '/'

  exec("mkdir -p #{base}#{httpAddress}", puts)

  x = pageName = _pageName = undefined
  i = -1
  casper.start "#{filename}/", ->
    # now x is an array of links
    x = links
    return

  casper.then ->
    @each x, ->
      ++i
      @thenOpen ("#{filename}/" + x[i]), ->
        @capture base + httpAddress + sep + @getTitle().replace(/\|/g, '-') + '.png'
        return
      return
    return

  casper.run()

#git.init "#{base}", true, (err, _repo) ->
  #repo = _repo
  #repo.add("#{base}#{httpAddress}")
  #repo.commit("Snapshot of #{httpAddress}")
  #repo.remote_push('develop')


siteRunner()


