package controllers

import (
	"GobDB"
	"errors"
	// "fmt"
)

type CarGobDB struct {
	DB      *GobDB.DB
	bagages *BagageGobDB
}

func NewCarGobDB(bagageDB *BagageGobDB) *CarGobDB {
	return &CarGobDB{
		DB:      GobDB.NewDB("cars", func() interface{} { var car Car; return &car }),
		bagages: bagageDB,
	}
}
func (db *CarGobDB) init() error {
	_, err := db.DB.Init()
	if err != nil {
		return err
	} else {
		db.every(func(c *Car) {
			c.dbLink = db
		})
		return nil
	}

}
func (db *CarGobDB) addCar(car *Car) error {
	return db.put(car.ID, car)
}
func (db *CarGobDB) put(id string, car *Car) error {
	return db.DB.Put(id, car)
}
func (db *CarGobDB) delete(id string) error {
	return db.DB.Delete(id)
}
func (db *CarGobDB) find(p carPredictor) CarList {
	list := CarList{}
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*Car)) {
			list = append(list, v.(*Car))
		}
	}
	return list
}
func (db *CarGobDB) findOne(p carPredictor) *Car {
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*Car)) {
			return v.(*Car)
		}
	}
	return nil
}
func (db *CarGobDB) every(f func(*Car)) {
	db.forEach(f, func(*Car) bool { return true })
}
func (db *CarGobDB) forEach(f func(*Car), p carPredictor) {
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*Car)) {
			f(v.(*Car))
		}
	}
}
func (db *CarGobDB) forOne(f func(*Car), p carPredictor) (*Car, error) {
	if u := db.findOne(p); u != nil {
		f(u)
		if err := db.delete(u.ID); err != nil {
			return nil, err
		}
		if err := db.put(u.ID, u); err != nil {
			return nil, err
		}
		return u, nil
	} else {
		return nil, errors.New("Not Found")
	}
}
func (db *CarGobDB) Has(id string) bool {
	return db.DB.Has(id)
}
