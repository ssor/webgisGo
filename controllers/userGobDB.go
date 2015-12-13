package controllers

import (
	"github.com/ssor/GobDB"
	// "GobDB"
	"errors"
	// "log"
)

type UserGobDB struct {
	DB   *GobDB.DB
	Cars *CarGobDB
}

func NewUserGobDB(carDB *CarGobDB) *UserGobDB {
	return &UserGobDB{
		DB:   GobDB.NewDB("users", func() interface{} { var user User; return &user }),
		Cars: carDB,
	}
}
func (db *UserGobDB) init() error {
	_, err := db.DB.Init()
	if err != nil {
		return err
	} else {
		db.every(func(u *User) {
			u.dbLink = db
		})
		return nil
	}
}

func (db *UserGobDB) Update(id string, user *User) error {
	return db.DB.Update(id, user)
}
func (db *UserGobDB) AddUser(user *User) error {
	return db.Update(user.Email, user)
}
func (db *UserGobDB) Put(id string, user *User) error {
	return db.DB.Put(id, user)
}
func (db *UserGobDB) Delete(id string) error {
	return db.DB.Delete(id)
}
func (db *UserGobDB) find(p userPredictor) UserList {
	list := UserList{}
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*User)) {
			list = append(list, v.(*User))
		}
	}
	return list
}
func (db *UserGobDB) every(f func(*User)) {
	db.forEach(f, func(*User) bool { return true })
}
func (db *UserGobDB) forEach(f func(*User), p userPredictor) {
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*User)) {
			f(v.(*User))
		}
	}
}
func (db *UserGobDB) findOne(p userPredictor) *User {
	// log.Println("60 userGobDB : ", db.DB)
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*User)) {
			return v.(*User)
		}
	}
	return nil
}
func (db *UserGobDB) forOne(f func(*User), p userPredictor) (*User, error) {
	// log.Println("69: ", db)
	if u := db.findOne(p); u != nil {
		f(u)
		if err := db.Delete(u.Email); err != nil {
			return nil, err
		}
		if err := db.Put(u.Email, u); err != nil {
			return nil, err
		}
		return u, nil
	} else {
		return nil, errors.New("Not Found")
	}
}
func (db *UserGobDB) Has(id string) bool {
	// return db.(*GobDB.DB).Has(id)
	return db.DB.Has(id)
}
