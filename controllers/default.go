package controllers

import (
	"errors"
	// "fmt"
	// "github.com/BurntSushi/toml"
	"github.com/astaxie/beego"
	// "strings"
)

type ResponseMsg struct {
	Code    int
	Message string
	Data    interface{}
}

func NewResponseMsg(code int, msg ...string) *ResponseMsg {
	message := ""
	if len(msg) > 0 {
		message = msg[0]
	}
	return &ResponseMsg{
		Code:    code,
		Message: message,
	}
}

type logicHandler func(m *MainController) (interface{}, error)

func responseHandler(m *MainController, handler logicHandler) {
	response := NewResponseMsg(0)
	defer func() {
		m.Data["json"] = response
		m.ServeJson()
	}()

	// //test
	// if m.GetSession("ID") == nil {
	// 	m.SetSession("ID", administrator)
	// }
	//****************************

	if m.GetSession("ID") == nil {
		DebugSysF("尚未登录")
		response = NewResponseMsg(1, "尚未登录")
		return
	}
	if value, err := handler(m); err != nil {
		DebugMustF("controller error: %s", err.Error())
		response = NewResponseMsg(1, err.Error())
	} else {
		response.Data = value
	}
}
func (m *MainController) getCurrentUser() (*User, error) {
	if s := m.GetSession("ID"); s == nil {
		userID := m.GetString("id")
		pwd := m.GetString("pwd")
		if len(userID) > 0 && len(pwd) > 0 {
			p := func(u *User) bool { return u.Email == userID && u.Password == pwd }
			if user := g_var.users.findOne(func(u *User) bool { return u.equal(p) }); user != nil {
				// if user := g_users.findOne(func(u *User) bool { return u.valid(userID, pwd) }); user != nil {
				DebugInfoF("login by api ")
				return user, nil
			}
		}
		DebugSysF("尚未登录")
		return nil, errors.New("尚未登录")
	} else {
		// DebugInfoF("getCurrentUser %s ", s)
		return s.(*User), nil
	}
}

type MainController struct {
	beego.Controller
}

func (m *MainController) Index() {
	m.TplNames = "index.tpl"
}
func (m *MainController) CheckLogin() {
	response := NewResponseMsg(0)
	defer func() {
		m.Data["json"] = response
		m.ServeJson()
	}()
	id := m.GetString("id")
	// if strings.Contains(id, "@") == false {
	// 	id = id + subfix
	// }
	pwd := m.GetString("pwd")
	p := func(u *User) bool { return u.Email == id && u.Password == pwd }
	if g_var.administrator.equal(p) {
		// if administrator.valid(id, pwd) {
		DebugInfoF("%s 登录", g_var.administrator.Email)
		m.SetSession("ID", g_var.administrator)
		return
	}
	user := g_var.users.findOne(func(u *User) bool { return u.equal(p) })
	if len(id) <= 0 || len(pwd) <= 0 || user == nil {
		response = NewResponseMsg(1, "用户名或者密码错误")
		// return nil, errors.New("用户名或者密码错误")
		return
	}
	m.SetSession("ID", user)
	DebugInfoF("%s 登录", user.Email)

}
func (m *MainController) Left() {
	if u, e := m.getCurrentUser(); e == nil {
		if u.equal(func(user *User) bool { return user.Email == g_var.administrator.Email }) {
			m.TplNames = "left_admin.tpl"
		} else {
			m.TplNames = "left.tpl"
		}
	}
}
func (m *MainController) Top() {
	m.TplNames = "top.tpl"
}
func (m *MainController) Right() {
	if u, e := m.getCurrentUser(); e == nil {
		if u.equal(func(user *User) bool { return user.Email == g_var.administrator.Email }) {
			// if u.equal(administrator) {
			m.TplNames = "userIndex.tpl"
		} else {
			m.TplNames = "right.tpl"
		}
	}
}
func (m *MainController) Main() {
	if _, err := m.getCurrentUser(); err != nil {
		m.Redirect("/", 302)
		return
	}
	m.TplNames = "main.tpl"
}
func (m *MainController) UserIndex() {
	m.TplNames = "userIndex.tpl"
}
func (m *MainController) Logout() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		m.DelSession("ID")
		return nil, nil
	})
}
func (m *MainController) UserList() {
	m.Data["json"] = g_var.users.find(func(u *User) bool { return u.Email != "admin" })
	m.ServeJson()
}
func (m *MainController) DeleteUser() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		id := m.GetString("id")
		// if g_users.exists(id) == false {

		if g_var.users.Has(id) == false {
			return nil, errors.New("用户名错误")
		}
		g_var.users.Delete(id)
		// saveUsers(g_users)
		return nil, nil
	})
}
func (m *MainController) AddUser() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		email := m.GetString("email")
		name := m.GetString("name")
		if len(email) <= 0 || len(name) <= 0 {
			return nil, errors.New("注册的用户名错误")
		}
		// if strings.Contains(email, "@") == false {
		// 	email = email + subfix
		// }

		if g_var.users.Has(email) == true {
			return nil, errors.New("用户名已被注册")
		}
		u := NewUser(email, default_password, name, g_var.users)
		// g_users = append(g_users, u)
		// u.save2db()
		g_var.users.Put(u.Email, u)
		return nil, nil
	})
}
func (m *MainController) CarIndex() {
	m.TplNames = "carIndex.tpl"
}

func (m *MainController) Cars() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		if u, err := m.getCurrentUser(); err == nil {
			return u.LinkedCars(), nil
		} else {
			return nil, err
		}
	})
}
func (m *MainController) DeleteCar() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		id := m.GetString("id")
		if u, err := m.getCurrentUser(); err == nil {
			u.removeCar(id)
			// u.save2db()
		}
		return nil, nil
	})
}
func (m *MainController) AddCar() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		id := m.GetString("carID")
		note := m.GetString("note")
		if u, err := m.getCurrentUser(); err == nil {
			if u.hasCar(id) == true {
				return nil, errors.New("该车已经被注册！")
			}
			u.addCar(NewCar(id, note, g_var.cars))
			// u.save2db()
		}
		return nil, nil
	})
}

func (m *MainController) BagageIndex() {
	m.TplNames = "bagageIndex.tpl"
}
func (m *MainController) BagageList() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		if u, err := m.getCurrentUser(); err == nil {
			return u.bagages(), nil
		}
		// DebugInfo("=> BagageList")
		return nil, nil
	})
}
func (m *MainController) AddBagageCarBinding() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		carID := m.GetString("carID")
		bagageID := m.GetString("bagageID")
		note := m.GetString("note")
		if len(carID) <= 0 || len(bagageID) <= 0 {
			return nil, errors.New("参数不规范")
		}
		if u, err := m.getCurrentUser(); err == nil {
			if u.hasCar(carID) {
				if e := u.addBagage(carID, NewBagage(bagageID, note)); e == nil {
					// saveUsers(g_users)
					// u.save2db()
					return nil, nil
				} else {
					return nil, e
				}
			} else {
				return nil, errors.New("no such car")
			}
		} else {
			return nil, err
		}
	})
}
func (m *MainController) RemoveBagageCarBinding() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		id := m.GetString("id")
		if u, err := m.getCurrentUser(); err == nil {
			u.removeBagage(id)
			// saveUsers(g_users)
			// u.save2db()
		}
		return nil, nil
	})
}
func (m *MainController) ChangePasswordIndex() {
	m.TplNames = "changepwd.tpl"
}

func (m *MainController) PostNewPassword() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		pwdNew := m.GetString("newpassword")
		pwdCrt := m.GetString("currentPassword")
		DebugTraceF("new : %s       crt: %s ", pwdNew, pwdCrt)
		if len(pwdNew) <= 0 || len(pwdCrt) <= 0 || pwdCrt == pwdNew {
			return nil, errors.New("新密码设置不符合要求")
		}
		idSession := m.GetSession("ID")
		if idSession == nil {
			return nil, errors.New("尚未登录")
		}
		if user, err := m.getCurrentUser(); err == nil {
			if e := user.setNewPwd(func(u *User) bool { return u.Password == pwdCrt }, pwdNew); e == nil {
				// if e := user.setNewPwd(pwdCrt, pwdNew); e == nil {
				DebugInfoF("密码已更新")
				// user.save2db()
			} else {
				return nil, e
			}
		}
		return nil, nil
	})
}
func (m *MainController) SetRoutePara() {
	m.TplNames = "setRoutePara.tpl"
}

// func (m *MainController) GetRoutePoints() {
// 	responseHandler(m, func(m *MainController) (interface{}, error) {
// 		// return nil, errors.New("no data")
// 		carID := m.GetString("carID")
// 		dateStart := m.GetString("dateStart")
// 		dateEnd := m.GetString("dateEnd")
// 		DebugTraceF("route para: %s from %s to %s", carID, dateStart, dateEnd)
// 		return g_positions.getPointsInSpecialTime(carID, dateStart, dateEnd), nil
// 	})
// }
func (m *MainController) StartReplaying() {
	m.TplNames = "startReplaying.tpl"
}
func (m *MainController) ChooseCarToMnt() {
	m.TplNames = "chooseCarToMnt.tpl"
}
func (m *MainController) Version() {
	m.TplNames = "version.tpl"
}
func (m *MainController) Resetpwd() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		id := m.GetString("id")
		// if g_users.exists(id) == false {
		if g_var.users.Has(id) == false {
			return nil, errors.New("用户ID错误")
		}
		pFindUser := func(u *User) bool { return u.Email == id }
		_, err := g_var.users.forOne(func(u *User) {
			u.setNewPwd(func(user *User) bool { return user.Password == u.Password }, default_password)
		}, pFindUser)
		if err != nil {
			return nil, err
		} else {
			// findedUser.save2db()
			// g_users.forOne(func(u *User) { u.setPwdDefault() }, func(u *User) bool { return u.Email == id })
			return nil, nil
		}
	})
}
func (m *MainController) StartMnting() {
	m.Data["carID"] = m.GetString("id")
	m.TplNames = "startMnting.tpl"
}
func (m *MainController) Getgps() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		carID := m.GetString("id")
		pos := m.GetSession("ID").(*User).getLatestPosition(carID)
		DebugTraceF("%s => %s", carID, pos)
		return pos, nil
	})
}
func (m *MainController) MobileLogin() {
	m.TplNames = "mobileLoginIndex.tpl"
}
func (m *MainController) MobileIndex() {
	m.Data["title"] = "位置获取"
	m.TplNames = "mobileIndex.tpl"
}
func (m *MainController) Uploadgps() {
	carID := m.GetString("carID")
	DebugInfoF("car (%s) redirect to uploadgps index", carID)
	m.Data["carID"] = carID
	m.TplNames = "uploadgps.tpl"
}
func (m *MainController) Postgps() {
	responseHandler(m, func(m *MainController) (interface{}, error) {
		carID := m.GetString("carID")
		Lat, err1 := m.GetFloat("Lat")
		Lng, err2 := m.GetFloat("Lng")
		if err1 != nil || err2 != nil {
			DebugSysF("%s %s", err1, err2)
			return nil, errors.New("上传位置信息错误")
		}
		pos := NewPosition(carID, Lat, Lng)
		if user, err := m.getCurrentUser(); err == nil {
			user.addPosition(pos)
			DebugTraceF("<= %s", pos)
			// DebugPrintList_Trace(g_positions)
			return nil, nil
		} else {
			return nil, err
		}
	})
}
