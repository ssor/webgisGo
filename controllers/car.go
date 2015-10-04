package controllers

import (
	// "fmt"
	"errors"
	// "github.com/astaxie/beego"
	"time"
)

type carPredictor func(*Car) bool

func NewCar(id, note string) *Car {
	// func NewCar(id, note string, owner Owner) *Car {
	addedTime := time.Now().Format("2006-01-02 15:04:05")
	return &Car{
		ID:        id,
		AddedTime: addedTime,
		Note:      note,
		Bagages:   BagageList{},
	}
}

// func (c *Car) getID() string {
// 	return c.ID
// }
func (c *Car) equal(car *Car) bool {
	return c.ID == car.ID
}
func (c *Car) removeBagage(id string) {
	c.Bagages = c.Bagages.remove(id)
}
func (c *Car) addBagage(b *Bagage) error {
	if c.hasBagage(b.ID) {
		return errors.New("alreay exits")
	} else {
		b.CarID = c.ID
		c.Bagages = append(c.Bagages, b)
		return nil
	}
}
func (c *Car) hasBagage(id string) bool {
	return c.Bagages.exists(id)
}
func (c *Car) getLatestPosition() *Positon {
	return c.LatestPosition
}
func (c *Car) refreshLatestPosition(pos *Positon) {
	c.LatestPosition = pos
}

func (cl CarList) exists(id string) bool {
	return cl.findOne(func(c *Car) bool { return c.ID == id }) != nil
}
func (cl CarList) remove(id string) CarList {
	return cl.removeRecursive(func(c *Car) bool { return c.ID == id }, CarList{})
}
func (cl CarList) forOne(f func(*Car), p carPredictor) error {
	if u := cl.findOne(p); u != nil {
		f(u)
	} else {
		return errors.New("Not Found")
	}
	return nil
}

func (cl CarList) findOne(f carPredictor) *Car {
	if len(cl) <= 0 {
		return nil
	}
	if f(cl[0]) == true {
		return cl[0]
	} else {
		return cl[1:].findOne(f)
	}
}
func (cl CarList) find(f carPredictor) CarList {
	return cl.findRecursive(f, CarList{})
}
func (cl CarList) findRecursive(f carPredictor, list CarList) CarList {
	if len(cl) <= 0 {
		return list
	}
	if f(cl[0]) {
		list = append(list, cl[0])
	}
	return cl[1:].findRecursive(f, list)
}
func (cl CarList) removeRecursive(f carPredictor, list CarList) CarList {
	if len(cl) <= 0 {
		return list
	}
	if f(cl[0]) {
		return append(list, cl[1:]...)
	} else {
		return cl[1:].removeRecursive(f, append(list, cl[0]))
	}
}
