# Compiles a Node.js project that uses Sass and CoffeeScript
#
# - generates one CSS in CSS_DIR file for each non-partial Sass file in SASS_DIR
# - generates a bundle.js file in JS_DIR by calling browserify on app.cjsx in
#   SRC_DIR
#
# TODO: make the browserify entry/exit points configurable
#
# Usage:
#
# - gulp
#   -> gulp styles && gulp scripts
# - gulp clean
#   -> rm -rf $CSS_DIR $JS_DIR
#
# - gulp styles
#   - builds Sass
# - gulp scripts
#   - builds CoffeeScript
#
# - gulp watch
#   - starts styles and scripts watchers in development mode
# - gulp watchify
#   - starts watchers just for CoffeeScript

_            = require 'underscore'

buffer       = require 'vinyl-buffer'
del          = require 'del'
gulp         = require 'gulp'
gutil        = require 'gulp-util'
source       = require 'vinyl-source-stream'

autoprefixer = require 'gulp-autoprefixer'
sass         = require 'gulp-sass'

browserify   = require 'browserify'
sourcemaps   = require 'gulp-sourcemaps'
uglify       = require 'gulp-uglify'
watchify     = require 'watchify'

# input Sass folder
SASS_DIR = './public/sass'
# output CSS folder
CSS_DIR = './public/css'
# input CoffeeScript/CJSX folder
SRC_DIR = './public/src'
# output JavaScript folder
JS_DIR = './public/js'

gulp.task 'clean', (cb) ->
  del [CSS_DIR, JS_DIR], cb

styles = (devMode) ->
  result = gulp.src "#{SASS_DIR}/**/*.s{a,c}ss"

  if devMode
    result = result.pipe sourcemaps.init()

  # Compile and compress sass
  result = result
    .pipe sass
      outputStyle: 'compressed'
    .on 'error', sass.logError

  if devMode
    # Fake that the sourcemapped files came from /sass
    result = result.pipe sourcemaps.write(sourceRoot: '/sass')

  result
    # Add CSS3 prefixes after sourcemaps so we get meaningful source mappings
    .pipe autoprefixer()
    .pipe gulp.dest(CSS_DIR)

gulp.task 'styles',     -> styles false
gulp.task 'styles-dev', -> styles true

scripts = (devMode) ->
  config = {}
  if devMode
    _.extend config, watchify.args
  _.extend config, debug: devMode

  # Initialize browserify
  # (it does it's own stream things when you call b.bundle())
  b = browserify "#{SRC_DIR}/app.cjsx", config

  if devMode
    b = watchify b
    b.on 'log', gutil.log.bind(gutil, 'watchify log')

  # This is where the real heavy lifting is done. In devMode, this will get
  # called by watchify on every update. Otherwise, it's called just once (as
  # the return of calling scripts(false) ).
  compile = ->
    result = b.bundle()
      .on 'error', gutil.log.bind(gutil, 'browserify error')
      # "call my the actual file of my bundle ..."
      .pipe source('bundle.js')
      # uglify and sourcemaps need a buffer, not a stream
      .pipe buffer()

    # For development, don't uglify, and add sourcemaps
    # For production, uglify, but don't add sourcemaps
    if devMode
      result = result
        # load maps from browserify file
        .pipe sourcemaps.init(loadMaps: true)
        # Fake that the sourcemapped files came from /src
        .pipe sourcemaps.write(sourceRoot: '/src')
    else
      result = result
        .pipe uglify()
        .on 'error', gutil.log.bind(gutil, 'uglify error')

    # "write my bundle to this directory"
    result.pipe gulp.dest(JS_DIR)

  if devMode
    # Recompile on changes for watchify
    b.on 'update', compile

  compile()

gulp.task 'scripts',  -> scripts false
gulp.task 'watchify', -> scripts true

gulp.task 'watch', ['watchify', 'styles-dev'], ->
  gulp.watch "#{SASS_DIR}/**/*.s{a,c}ss", ['styles-dev']

gulp.task 'default', ->
  gulp.start 'styles', 'scripts'
  null
