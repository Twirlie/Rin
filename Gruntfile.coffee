module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        expand: true,
        flatten: true,
        cwd: './',
        src: ['src/*.coffee'],
        dest: 'lib/',
        ext: '.js'
      }
    },
    less: {
      development: {
        files: {
          './public/style.css': 'src/stylesheets/style.less'
        }
      }
    }
  }
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-less')

  grunt.registerTask('default', 'Compiles the CoffeeScript and less', ['coffee', 'less'])