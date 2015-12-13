package controllers

import (
	// "fmt"
	"github.com/ungerik/go-dry"
	// "github.com/astaxie/beego"
	// "GobDB"
	"errors"
	// "os"
	// "log"
)

type UserList []*User

type User struct {
	Password string
	Email    string
	UserName string
	Cars     []string
	dbLink   *UserGobDB
	// Cars     CarList
}

type userPredictor func(*User) bool

func NewUser(email, pwd, name string, dbLink *UserGobDB) *User {
	return &User{
		Email:    email,
		Password: pwd,
		UserName: name,
		Cars:     []string{},
		dbLink:   dbLink,
	}
}

// func DB2UserList(db *GobDB.DB) UserList {
// 	list := UserList{}
// 	for _, v := range db.ObjectsMap {
// 		list = append(list, v.(*User))
// 	}
// 	return list
// }

// func (u *User) save2db() {
// 	if g_dbUser.Has(u.Email) == true {
// 		if err := g_dbUser.Delete(u.Email); err != nil {
// 			DebugSysF("delete user info error: %s", err)
// 			return
// 		}
// 	}
// 	g_dbUser.Put(u.Email, u)
// }
// func (u *User) removeDB() {
// 	if err := g_dbUser.Delete(u.Email); err != nil {
// 		DebugSysF("delete user info error: %s", err)
// 		return
// 	}

// 	// if err := os.Remove(fmt.Sprintf(userDataFileFormat, u.Email+".toml")); err != nil {
// 	// 	DebugSysF("remove user info error: %s", err)
// 	// }
// }
func (u *User) LinkedCars() CarList {
	// log.Println(u.dbLink)
	DebugTraceF("user %s try to get linked cars: %s", u.Email, u.Cars)
	return u.dbLink.Cars.find(func(car *Car) bool { return dry.StringListContains(u.Cars, car.ID) })
}
func (u *User) bagageExists(id string) bool {
	return u.LinkedCars().findOne(func(car *Car) bool { return car.hasBagage(id) }) != nil
}
func (u *User) addBagage(carID string, bagage *Bagage) error {
	if u.bagageExists(bagage.ID) {
		return errors.New("bagage already exists")
	} else {
		if car := u.LinkedCars().findOne(func(car *Car) bool { return car.ID == carID }); car != nil {
			car.addBagage(bagage)
			return nil
		} else {
			return errors.New("car not exists")
		}
	}
}
func (u *User) removeBagage(bagageID string) {
	if car := u.LinkedCars().findOne(func(car *Car) bool { return car.hasBagage(bagageID) }); car != nil {
		car.removeBagage(bagageID)
	}
}
func (u *User) bagages() BagageList {
	l := BagageList{}
	// l := []string{}
	for _, car := range u.LinkedCars() {
		l = append(l, car.LinkedBagages()...)
	}
	return l
}
func (u *User) addCar(car *Car) error {
	if u.LinkedCars().exists(car.ID) {
		return errors.New("already exists")
	} else {
		// car.Owner = u.Email
		if err := u.dbLink.Cars.put(car.ID, car); err != nil {
			DebugMustF("%s", err)
			return errors.New("error when save car info")
		}
		u.Cars = append(u.Cars, car.ID)
		if err := u.dbLink.Update(u.Email, u); err != nil {
			DebugMustF("%s", err)
			u.removeCar(car.ID)
			return errors.New("error when update user info")
		}
		return nil
	}
}
func (u *User) removeCar(id string) {
	// u.Cars = u.Cars.remove(id)
	u.Cars = dry.StringFilter(func(s string) bool {
		return s != id
	}, u.Cars)
	u.dbLink.Cars.delete(id)
}
func (u *User) hasCar(id string) bool {
	// return u.Cars.exists(id)
	return dry.StringListContains(u.Cars, id)
}
func (u *User) addPosition(pos *Positon) {
	if car := u.LinkedCars().findOne(func(car *Car) bool { return car.ID == pos.CarID }); car != nil {
		car.refreshLatestPosition(pos)
	}
}
func (u *User) getLatestPosition(carID string) *Positon {
	if car := u.LinkedCars().findOne(func(car *Car) bool { return car.ID == carID }); car != nil {
		return car.getLatestPosition()
	}
	return nil
}

// func (u *User) equal(user *User) bool {
// 	return u.Email == user.Email && u.Password == user.Password
// }
// func (u *User) valid(email, pwd string) bool {
// 	return u.Email == email && u.Password == pwd
// }
// func (u *User) isCurrentPwd(pwd string) bool {
// 	return u.Password == pwd
// }
func (u *User) equal(p userPredictor) bool {
	return p(u)
}

func (u *User) setNewPwd(p userPredictor, pwdNew string) error {
	// func (u *User) setNewPwd(pwdCrt, pwdNew string) error {
	id := u.Email
	if p(u) {
		_, err := u.dbLink.forOne(func(u *User) {
			u.Password = pwdNew
		}, func(_u *User) bool {
			return _u.Email == id
		})
		return err
		// 	u.Password = pwdNew
	} else {
		return errors.New("当前密码错误！")
	}
	// return nil
}

//-------------------------------------------------------------------------------
// func (ul UserList) exists(email string) bool {
// 	// return ul.findOne(func(u *User) bool { return u.Email == email }) != nil
// 	// _, ok := ul.List.ObjectsMap[email]
// 	_, ok := ul.ObjectsMap[email]
// 	return ok
// }

// func (ul UserList) remove(email string) UserList {
// 	return ul.removeRecursive(func(u *User) bool { return u.Email == email }, UserList{})
// }
// func (ul UserList) find(p userPredictor) UserList {
// 	return ul.findRecursive(UserList{}, p)
// }
// func (ul UserList) findRecursive(list UserList, p userPredictor) UserList {
// 	if len(ul) <= 0 {
// 		return list
// 	}
// 	if p(ul[0]) {
// 		return ul[1:].findRecursive(append(list, ul[0]), p)
// 	} else {
// 		return ul[1:].findRecursive(list, p)
// 	}
// }
// func (ul UserList) forOne(f func(*User), p userPredictor) (*User, error) {
// 	if u := ul.findOne(p); u != nil {
// 		f(u)
// 		return u, nil
// 	} else {
// 		return nil, errors.New("Not Found")
// 	}
// }
// func (ul UserList) findOne(p userPredictor) *User {
// 	if len(ul) <= 0 {
// 		return nil
// 	}
// 	if p(ul[0]) {
// 		return ul[0]
// 	} else {
// 		return ul[1:].findOne(p)
// 	}
// }
// func (ul UserList) removeRecursive(f userPredictor, list UserList) UserList {
// 	if len(ul) <= 0 {
// 		return list
// 	}
// 	if f(ul[0]) {
// 		ul[0].removeDB()
// 		return append(list, ul[1:]...)
// 	} else {
// 		return ul[1:].removeRecursive(f, list)
// 	}
// }
