package main

import (
	"github.com/astaxie/beego"
	_ "webgisGo/routers"
)

func main() {
	beego.SessionOn = true
	beego.SetStaticPath("/javascripts", "static/javascripts")
	beego.SetStaticPath("/bootstrap", "static/bootstrap")
	beego.SetStaticPath("/Image", "static/Image")
	beego.SetStaticPath("/dataTable", "static/dataTable")
	beego.SetStaticPath("/stylesheets", "static/css")
	// beego.SetStaticPath("/easyUI", "static/easyUI")
	beego.Run()
}
