package controllers

import (
	"errors"
	"fmt"
	"github.com/BurntSushi/toml"
	"github.com/ungerik/go-dry"
	"os"
	// "github.com/astaxie/beego"
	// "strings"
)

var (
	userDataFile  = "./data/users.toml"
	adminDataFile = "./data/admin.toml"
)

type usersInfo struct {
	Users UserList
}

func jiechengTail(n, result int) int {
	if n == 0 {
		return result
	}
	return jiechengTail(n-1, result*n)
}
func jiecheng(n int) int {
	if n == 0 {
		return 1
	}
	return n * jiecheng(n-1)
}
func init() {
	administrator = loadAdminInfo()
	if administrator == nil {
		administrator = &User{
			UserName: "系统管理员",
			Email:    "admin" + subfix,
			Password: default_password,
		}
	}

	g_users = loadUsers()
	if g_users == nil {
		g_users = UserList{}
	} else {
		DebugInfoF("%d total users loaded", len(g_users))
	}
}

func saveUserInfo(user *User) error {
	return saveData(adminDataFile, user)
}
func loadAdminInfo() *User {
	u := &User{}
	if e := loadData(adminDataFile, u); e == nil {
		return u
	} else {
		return nil
	}
}
func saveUsers(users UserList) error {
	return saveData(userDataFile, usersInfo{users})
}
func loadUsers() UserList {
	ui := &usersInfo{}
	if e := loadData(userDataFile, ui); e == nil {
		DebugInfoF("load user info sucess")
	} else {
		DebugSysF("load user info failed: %s", e)
		return nil
	}
	if ui != nil {
		return ui.Users
	}
	return nil
	// return ui.users
}

//载入数据
func loadData(filePath string, data interface{}) error {
	if dry.FileExists(filePath) == false {
		return errors.New(fmt.Sprintf("文件 %s 不存在", filePath))
	}
	_, err := toml.DecodeFile(filePath, data)
	return err
}
func saveData(filePath string, data interface{}) error {
	fmt.Printf("%+v \n", data)
	fileData, err := os.Create(filePath)
	if err != nil {
		DebugMustF("创建文件出错：%s", err)
		return err
	}
	defer func() {
		fileData.Close()
		DebugInfoF("save %s success", filePath)
	}()
	err = toml.NewEncoder(fileData).Encode(data)
	if err != nil {
		DebugMustF("保存数据到文件时出错：%s", err)
		return err
	}
	return nil
}
