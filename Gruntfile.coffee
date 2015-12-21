module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    uglify:
      build:
        files:
          'src/js/project/<%= pkg.name %>.min.js':
            [
              'src/js/project/<%= pkg.name %>.js'
            ]

    coffee:
      options:
        join: true
      project:
        files:
          'src/js/project/<%= pkg.name %>.js':
            [
              'src/coffee/project/*.coffee'
            ]
      server:
        files:
          'src/js/server/server.js':
            [
              'src/coffee/server/*.coffee'
            ]
    express:
      options: {}
      dev:
        options:
          script: 'src/js/server/server.js'
    watch:
      project:
        files: 'src/coffee/project/*.coffee'
        tasks:
          [
            'coffee:project',
            'uglify'
          ]
      server:
        files: 'src/coffee/server/*.coffee'
        tasks:
          [
            'coffee:server'
            'express:dev'
          ]
        options:
          spawn: false


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.registerTask 'default', ['coffee', 'uglify', 'express:dev', 'watch']
  grunt.registerTask 'noserver', ['coffee', 'uglify', 'watch:project']
  grunt.registerTask 'nowatch', ['coffee', 'uglify', 'express:dev']
