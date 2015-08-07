#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "Please provide a project name"
    exit 1
fi

# Save project name
PROJECT_NAME="$1"

# CSS + JS CONTENT
function ACTIVE_BODY
{
    echo "/*!
 * $PROJECT_NAME
 *
 * MIT licensed
 * Copyright (C) 2015 Thibaut Villemont, http://moderntree.net
 */
"
}

# CSS + JS CONTENT
function LESS_BODY
{
    echo "@import 'base'; /*normalize.css*/"
}

# HTML CONTENT
function HTML_BODY
{
    echo '<!DOCTYPE html>
<html class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>'$PROJECT_NAME'</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" href="assets/css/main.min.css">
        <!--<script src="js/vendor/modernizr-2.7.1.min.js"></script>-->
    </head>
    <body>

        <!--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> -->
        <script src="assets/js/main.min.js"></script>
 
    </body>
</html>'
}

function JS_BODY
{
    echo "
var App = (function () {

    return {
        init: function() {
           
        }
    };

})();"
}

function PACKAGE_BODY
{
    echo '{
    "name": "'$PROJECT_NAME'",
    "version": "0.0.1",
    "private": true,
    "devDependencies": {
        "grunt": "~0.4.2",
        "grunt-contrib-uglify": "~0.3.1",
        "grunt-contrib-jshint": "~0.8.0",
        "grunt-contrib-qunit": "~0.4.0",
        "grunt-contrib-watch": "~0.5.3",
        "grunt-contrib-concat": "~0.3.0",
        "grunt-contrib-connect": "^0.11.2",
        "grunt-recess": "~0.5.0"
    }
}'
}

function GRUNT_BODY
{
    echo "/*
     * grunt-init
     * https://gruntjs.com/
     *
     * Copyright (c) 2014 \"Cowboy\" Ben Alman, contributors
     * Licensed under the MIT license.
     */

    'use strict';

    module.exports = function(grunt) {

      // Project configuration.
      grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        concat: {
          dist: {
            src: ['node_modules/normalize.css/normalize.css'],
            dest: 'assets/less/base.less'
          }
        },

        jshint: {
          all: [
            'Gruntfile.js',
            'assets/js/*.js',
          ],
          options: {
            globals: {
              jQuery: true,
              console: false,
              module: true
            }
          }
        },

        uglify: {
          dist: {
            files: {
              'assets/js/main.min.js': ['assets/js/main.js']
            }
          }
        },

        recess: {
          options: {
            compile: true,
            banner: '<%= banner %>'
          },
          main: {
            src: ['assets/less/main.less'],
            dest: 'assets/css/main.css'
          },
          min: {
            options: {
              compress: true
            },
            src: ['assets/less/main.less'],
            dest: 'assets/css/main.min.css'
          }
        },

        connect: {
          server: {
            options: {
              port: 8081,
              hostname: 'localhost'
            }
          }
        },


        watch: {
          js: {
            files: ['assets/js/*.js'],
            tasks: ['uglify:dist'],
            options: {
              livereload: true,
            }
          },
          less: { 
            files: ['assets/less/*.less'],
            tasks: ['concat','recess'],
            options: {
              livereload: true,
            }
          }
        }
      });

      // These plugins provide necessary tasks.
      grunt.loadNpmTasks('grunt-contrib-concat');
      grunt.loadNpmTasks('grunt-contrib-jshint');
      grunt.loadNpmTasks('grunt-contrib-uglify');
      grunt.loadNpmTasks('grunt-contrib-watch');
      grunt.loadNpmTasks('grunt-recess');
      grunt.loadNpmTasks('grunt-contrib-connect');

      // By default, lint and run all tests.
      grunt.registerTask('default', ['concat','uglify','recess']);
      grunt.registerTask('serve', ['connect', 'watch']);

    };"
}


# Create The directories
mkdir -p "$PROJECT_NAME"
mkdir -p "$PROJECT_NAME/assets"
mkdir -p "$PROJECT_NAME/assets/js"
mkdir -p "$PROJECT_NAME/assets/css"
mkdir -p "$PROJECT_NAME/assets/less"

# CSS/LESS
touch "$PROJECT_NAME/assets/less/main.less"
LESS_BODY > "$PROJECT_NAME/assets/less/main.less"

# JS
touch "$PROJECT_NAME/assets/js/main.js"
ACTIVE_BODY > "$PROJECT_NAME/assets/js/main.js"
JS_BODY >> "$PROJECT_NAME/assets/js/main.js"

# PACKAGE
touch "$PROJECT_NAME/package.json"
PACKAGE_BODY > "$PROJECT_NAME/package.json"

# GRUNT
touch "$PROJECT_NAME/Gruntfile.js"
GRUNT_BODY > "$PROJECT_NAME/Gruntfile.js"

# # INDEX
touch "$PROJECT_NAME/index.html"
HTML_BODY > "$PROJECT_NAME/index.html"

echo "
-----
OK
-----"

# go to path
cd $PROJECT_NAME

# install grunt dependecies
npm install

# install normalize CSS
npm install --save normalize.css
