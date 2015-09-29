package routers

import (
	"github.com/astaxie/beego"
	"webgisGo/controllers"
)

func init() {
	// beego.Router("/", &controllers.MainController{},  )
	beego.Router("/", &controllers.MainController{}, "GET:Index")
	beego.Router("/index", &controllers.MainController{}, "GET:Index")
	beego.Router("/checkLogin", &controllers.MainController{}, "POST:CheckLogin")
	beego.Router("/right", &controllers.MainController{}, "GET:Right")
	beego.Router("/left", &controllers.MainController{}, "GET:Left")
	beego.Router("/top", &controllers.MainController{}, "GET:Top")
	beego.Router("/main", &controllers.MainController{}, "GET:Main")

	beego.Router("/userIndex", &controllers.MainController{}, "GET:UserIndex")
	beego.Router("/users", &controllers.MainController{}, "GET:UserList")
	beego.Router("/chooseCarToMnt", &controllers.MainController{}, "GET:ChooseCarToMnt")
	beego.Router("/startMnting", &controllers.MainController{}, "GET:StartMnting")
	// beego.Router("/startBagageMnting/:bagageID", &controllers.MainController{}, "GET:StartBagageMnting")
	// beego.Router("/logout", &controllers.MainController{}, "GET:Logout")
	beego.Router("/version", &controllers.MainController{}, "GET:Version")
	// beego.Router("/errorPage", &controllers.MainController{}, "GET:ErrorPage")
	beego.Router("/users", &controllers.MainController{}, "POST:AddUser")
	beego.Router("/users", &controllers.MainController{}, "DELETE:DeleteUser")

	beego.Router("/changePassword", &controllers.MainController{}, "GET:ChangePasswordIndex")
	beego.Router("/postNewPassword", &controllers.MainController{}, "POST:PostNewPassword")
	beego.Router("/resetpwd", &controllers.MainController{}, "GET:Resetpwd")

	beego.Router("/carIndex", &controllers.MainController{}, "GET:CarIndex")
	beego.Router("/cars", &controllers.MainController{}, "GET:Cars")
	beego.Router("/cars", &controllers.MainController{}, "POST:AddCar")
	beego.Router("/cars", &controllers.MainController{}, "DELETE:DeleteCar")
	// beego.Router("/carListForClient", &controllers.MainController{}, "POST:CarListForClient")
	// beego.Router("/carTypeList", &controllers.MainController{}, "GET:CarTypeList")

	beego.Router("/mobileLogin", &controllers.MainController{}, "GET:MobileLogin")
	beego.Router("/mobile", &controllers.MainController{}, "GET:MobileIndex")
	beego.Router("/uploadgps", &controllers.MainController{}, "GET:Uploadgps")
	beego.Router("/postgps", &controllers.MainController{}, "POST:Postgps")
	beego.Router("/getgps", &controllers.MainController{}, "GET:Getgps")
	beego.Router("/setRoutePara", &controllers.MainController{}, "GET:SetRoutePara")
	// beego.Router("/getRoutePoints", &controllers.MainController{}, "POST:GetRoutePoints")
	beego.Router("/startReplaying", &controllers.MainController{}, "GET:StartReplaying")
	// beego.Router("/getRoutePointList", &controllers.MainController{}, "GET:GetRoutePointList")

	beego.Router("/bagageIndex", &controllers.MainController{}, "GET:BagageIndex")
	beego.Router("/bagages", &controllers.MainController{}, "GET:BagageList")
	beego.Router("/bagages", &controllers.MainController{}, "DELETE:RemoveBagageCarBinding")
	// app.post('/addBagageCarBinding', bagage.addBagageCarBinding);
	// app.post('/removeBagageCarBinding', bagage.removeBagageCarBinding);
	// app.post('/removeBagageCarBindingForClient', bagage.removeBagageCarBindingForClient);
	// app.post('/gerBagageRecord', bagage.gerBagageRecord);
	// app.get('/bagageStatusIndex/:bagageID', bagage.bagageStatusIndex);
	// app.post('/getBagageStatus', bagage.getBagageStatus);
	// app.get('/b', bagage.bagageLoginIndex);
	// app.get('/getBagageExits/:bagageID', bagage.getBagageExits);
	// app.post('/bagageListBindedWithCarID', bagage.bagageListBindedWithCarID);
	// app.get('/getBagageStatus4Weixin/:bagageID', bagage.getBagageStatus4Weixin);

}
