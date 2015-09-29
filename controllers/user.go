package controllers

import (
	"fmt"
	// "github.com/astaxie/beego"
	"errors"
)

// var administrator = &User{
// 	// UserID:   "admin",
// 	UserName: "系统管理员",
// 	Email:    "admin" + subfix,
// 	Password: default_password,
// 	// Email:    "admin@iot-top.com",
// }

type userPredictor func(*User) bool

type User struct {
	// UserID,
	Email, Password, UserName string
	Cars                      CarList
}

func NewUser(email, pwd, name string) *User {
	return &User{
		Email:    email,
		Password: pwd,
		UserName: name,
		Cars:     CarList{},
	}
}
func (u *User) String() string {
	return fmt.Sprintf("ID: %s  Name: %s  Cars: %d", u.Email, u.UserName, len(u.Cars))
}

// func (u *User) ID() string {
// 	return u.Email
// }
func (u *User) bagageExists(id string) bool {
	return u.Cars.findOne(func(car *Car) bool { return car.hasBagage(id) }) != nil
}
func (u *User) addBagage(carID string, bagage *Bagage) error {
	if u.bagageExists(bagage.ID) {
		return errors.New("bagage already exists")
	} else {
		if car := u.Cars.findOne(func(car *Car) bool { return car.ID == carID }); car != nil {
			car.addBagage(bagage)
			return nil
		} else {
			return errors.New("car not exists")
		}
	}
}
func (u *User) removeBagage(bagageID string) {
	if car := u.Cars.findOne(func(car *Car) bool { return car.hasBagage(bagageID) }); car != nil {
		car.removeBagage(bagageID)
	}
}
func (u *User) bagages() BagageList {
	l := BagageList{}
	for _, car := range u.Cars {
		l = append(l, car.Bagages...)
	}
	return l
}
func (u *User) addCar(car *Car) error {
	if u.Cars.exists(car.ID) {
		return errors.New("already exists")
	} else {
		car.Owner = u.Email
		u.Cars = append(u.Cars, car)
		return nil
	}
}
func (u *User) removeCar(id string) {
	u.Cars = u.Cars.remove(id)
}
func (u *User) hasCar(id string) bool {
	return u.Cars.exists(id)
}
func (u *User) addPosition(pos *Positon) {
	if car := u.Cars.findOne(func(car *Car) bool { return car.ID == pos.CarID }); car != nil {
		car.refreshLatestPosition(pos)
	}

}
func (u *User) getLatestPosition(carID string) *Positon {
	if car := u.Cars.findOne(func(car *Car) bool { return car.ID == carID }); car != nil {
		return car.getLatestPosition()
	}
	return nil
}
func (u *User) equal(user *User) bool {
	return u.Email == user.Email && u.Password == user.Password
}
func (u *User) valid(email, pwd string) bool {
	return u.Email == email && u.Password == pwd
}
func (u *User) setPwdDefault() {
	u.Password = default_password
}
func (u *User) setNewPwd(pwdCrt, pwdNew string) error {
	if u.Password == pwdCrt {
		u.Password = pwdNew
	} else {
		return errors.New("当前密码错误！")
	}
	return nil
}
func (u *User) isCurrentPwd(pwd string) bool {
	return u.Password == pwd
}

type UserList []*User

// func (ul UserList) carExists(id string) bool {
// 	return ul.findOne(func(u *User) bool { return u.hasCar(id) }) != nil
// }

func (ul UserList) exists(email string) bool {
	return ul.findOne(func(u *User) bool { return u.Email == email }) != nil
}

func (ul UserList) remove(email string) UserList {
	return ul.removeRecursive(func(u *User) bool { return u.Email == email }, UserList{})
}
func (ul UserList) forOne(f func(*User), p userPredictor) error {
	if u := ul.findOne(p); u != nil {
		f(u)
	} else {
		return errors.New("Not Found")
	}
	return nil
}
func (ul UserList) findOne(p userPredictor) *User {
	if len(ul) <= 0 {
		return nil
	}
	if p(ul[0]) {
		return ul[0]
	} else {
		return ul[1:].findOne(p)
	}
}
func (ul UserList) removeRecursive(f userPredictor, list UserList) UserList {
	if len(ul) <= 0 {
		return list
	}
	if f(ul[0]) {
		return append(list, ul[1:]...)
	} else {
		return ul[1:].removeRecursive(f, list)
	}
}
