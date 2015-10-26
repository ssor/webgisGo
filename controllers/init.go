package controllers

import (
	// "GobDB"
	"fmt"
	// "errors"
	// "github.com/BurntSushi/toml"
	// "github.com/ungerik/go-dry"
	// "log"
	// "os"
	// "github.com/astaxie/beego"
	// "strings"
)

type global_var struct {
	administrator *User
	users         *UserGobDB
	cars          *CarGobDB
	bagages       *BagageGobDB
}

func (g *global_var) init() error {
	g_var.bagages = NewBagageGobDB()
	g_var.cars = NewCarGobDB(g_var.bagages)
	g_var.users = NewUserGobDB(g_var.cars)

	if err := g_var.users.init(); err != nil {
		DebugMust(fmt.Sprintf("初始化用户数据出错: %s", err))
		return err
	} else {
		if admin := g_var.users.DB.Get("admin"); admin == nil {
			g_var.administrator = adminDefaultInfo
			g_var.administrator.dbLink = g_var.users
			g_var.users.Put(g_var.administrator.Email, g_var.administrator)
			DebugInfoF("初始化系统，管理员信息默认")
		} else {
			g_var.administrator = admin.(*User)
			DebugInfoF("载入管理员信息成功")
		}
		DebugInfoF("载入了 %d 个用户信息", len(g_var.users.DB.ObjectsMap))
	}
	if err := g_var.cars.init(); err != nil {
		DebugMustF("初始化车辆信息出错：%s", err)
		return err
	}
	if err := g_var.bagages.init(); err != nil {
		DebugMustF("初始化订单信息出错：%s", err)
		return err
	}
	return nil
}

var (
	// userDataFile  = "./data/users.toml"
	// adminDataFile = "./data/admin.toml"
	// dbDir              = "./data/"
	// userDataFileFormat = "./data/%s"
	default_password = "111"
	adminDefaultInfo = &User{
		UserName: "系统管理员",
		Email:    "admin",
		Password: default_password,
	}
	g_var *global_var = &global_var{}
	// g_users       UserList
	// administrator *User
	// g_dbUser *UserGobDB = &UserGobDB{GobDB.NewDB("users", func() interface{} { var user User; return &user })}
	// g_dbUser      *GobDB.DB = GobDB.NewDB("users", func() interface{} { var user User; return &user })
	// g_dbCar    *GobDB.DB = GobDB.NewDB("cars", func() interface{} { var car Car; return &car })
	// g_dbBagage *GobDB.DB = GobDB.NewDB("bagages", func() interface{} { var b Bagage; return &b })
)

func init() {
	g_var.init()
	// if administrator == nil {
	// }
	// g_dbUser.Exists("")
}

// func (db *GobDB.DB) Exists(id string) bool {
// 	return db.Has(id)
// }

// func loadUsersFromDB(files []string) UserList {
// 	return loadUsersFromDBRecursive(files, UserList{})
// }
// func loadUsersFromDBRecursive(files []string, list UserList) UserList {
// 	if len(files) <= 0 {
// 		return list
// 	}
// 	user := loadUserInfoFromDB(files[0])
// 	if user == nil {
// 		DebugSysF("load user %s error", files[0])
// 	} else {
// 		list = append(list, user)
// 	}
// 	return loadUsersFromDBRecursive(files[1:], list)
// }

// func loadUserInfoFromDB(file string) *User {
// 	var u User
// 	file = fmt.Sprintf(userDataFileFormat, file)
// 	if e := loadData(file, &u); e == nil {
// 		return &u
// 	} else {
// 		DebugSysF("load user info from db error: %s", e)
// 		return nil
// 	}
// }

// //载入数据
// func loadData(filePath string, data interface{}) error {
// 	if dry.FileExists(filePath) == false {
// 		return errors.New(fmt.Sprintf("文件 %s 不存在", filePath))
// 	}
// 	_, err := toml.DecodeFile(filePath, data)
// 	return err
// }
// func saveData(filePath string, data interface{}) error {
// 	fmt.Printf("%+v \n", data)
// 	fileData, err := os.Create(filePath)
// 	if err != nil {
// 		DebugMustF("创建文件出错：%s", err)
// 		return err
// 	}
// 	defer func() {
// 		fileData.Close()
// 		DebugInfoF("save %s success", filePath)
// 	}()
// 	err = toml.NewEncoder(fileData).Encode(data)
// 	if err != nil {
// 		DebugMustF("保存数据到文件时出错：%s", err)
// 		return err
// 	}
// 	return nil
// }
