####################
# Initialization
####################
express = require "express"
mongoose = require "mongoose"
bodyParser = require "body-parser"
path = require "path"
Schema = mongoose.Schema

app = express()
app.use bodyParser.json()

tmp = __dirname.split path.sep
tmp.pop()
js_dir = path.join tmp.join(path.sep), "project"
app.use '/lib/src', express.static js_dir

tmp.pop()
html_dir = path.join tmp.join(path.sep), "html"
app.use '/', express.static html_dir

css_dir = path.join tmp.join(path.sep), "css"
app.use '/lib/src/css', express.static css_dir

tmp.pop()
root_dir = tmp.join path.sep

domreplay_dir = path.join root_dir, "node_modules", "DOMReplay", "src", "js"
app.use '/lib/domreplay', express.static domreplay_dir

angular_dir = path.join root_dir, "bower_components", "angular"
app.use '/lib/angular', express.static angular_dir

angular_bootstrap_dir = path.join root_dir, "bower_components", "angular-bootstrap"
app.use '/lib/angular-bootstrap', express.static angular_bootstrap_dir

angular_resource_dir = path.join root_dir, "bower_components","angular-resource"
app.use '/lib/angular-resource', express.static angular_resource_dir

angular_route_dir = path.join root_dir, "bower_components", "angular-route"
app.use '/lib/angular-route', express.static angular_route_dir

angular_animate_dir = path.join root_dir, "bower_components", "angular-animate"
app.use '/lib/angular-animate', express.static angular_animate_dir

bootstrap_dir = path.join root_dir, "bower_components", "bootstrap", "dist"
app.use '/lib/bootstrap', express.static bootstrap_dir

console.log bootstrap_dir

PORT = 3000
URL = '127.0.0.1'
