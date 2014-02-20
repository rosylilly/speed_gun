module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig(
    watch:
      files: ['coffee/**/*.coffee'],
      tasks: ['coffee','uglify']
    coffee:
      compile:
        options:
          sourceMap: true
        files: [
            expand: true,
            cwd: 'coffee/',
            src: ['**/*.coffee'],
            dest: 'uncompressed-js/',
            ext: '.js'
        ]
    uglify:
      compress_target:
        options:
          sourceMap: (fileName) ->
            fileName.replace /\.js$/, '.js.map'
        files: [
            expand: true,
            cwd: 'uncompressed-js/',
            src: ['**/*.js'],
            dest: 'js/',
            ext: '.js'
        ]
  )

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask('default', ['watch'])
