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
	// userDataFile  = "./data/users.toml"
	// adminDataFile = "./data/admin.toml"
	dbDir = "./data/"

	adminDefaultInfo = &User{
		UserName: "系统管理员",
		Email:    "admin",
		Password: default_password,
	}
)

func init() {
	files, err := dry.ListDirFiles(dbDir)
	if err == nil {
		g_users = loadUsersFromDB(files)
		DebugInfoF("%d total users loaded", len(g_users))
	}

	administrator = loadUserInfoFromDB("admin.toml")
	if administrator == nil {
		administrator = adminDefaultInfo
	}
}
func loadUsersFromDB(files []string) UserList {
	return loadUsersFromDBRecursive(files, UserList{})
}
func loadUsersFromDBRecursive(files []string, list UserList) UserList {
	if len(files) <= 0 {
		return list
	}
	user := loadUserInfoFromDB(files[0])
	if user == nil {
		DebugSysF("load user %s error", files[0])
	} else {
		list = append(list, user)
	}
	return loadUsersFromDBRecursive(files[1:], list)
}

func loadUserInfoFromDB(file string) *User {
	var u User
	file = fmt.Sprintf(userDataFileFormat, file)
	if e := loadData(file, &u); e == nil {
		return &u
	} else {
		DebugSysF("load user info from db error: %s", e)
		return nil
	}
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
