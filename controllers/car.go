package controllers

import (
	"errors"
	"fmt"
	"github.com/ssor/GobDB"
	"github.com/ungerik/go-dry"
	// "github.com/astaxie/beego"
	// "GobDB"
	"time"
)

type CarList []*Car

type Car struct {
	ID, AddedTime, Note string
	Bagages             []string
	LatestPosition      *Positon
	dbLink              *CarGobDB
	// Owner               string
	// Bagages             BagageList `json:"-"`
}

func (c *Car) String() string {
	return fmt.Sprintf("id: %s AddedTime: %s", c.ID, c.AddedTime)
}

type carPredictor func(*Car) bool

func NewCar(id, note string, dbLink *CarGobDB) *Car {
	// func NewCar(id, note string, owner Owner) *Car {
	addedTime := time.Now().Format("2006-01-02 15:04:05")
	return &Car{
		ID:        id,
		AddedTime: addedTime,
		Note:      note,
		Bagages:   []string{},
		dbLink:    dbLink,
	}
}
func DB2CarList(db *GobDB.DB) CarList {
	list := CarList{}
	for _, v := range db.ObjectsMap {
		list = append(list, v.(*Car))
	}
	return list
}
func (c *Car) LinkedBagages() BagageList {
	return c.dbLink.bagages.find(func(b *Bagage) bool {
		return dry.StringListContains(c.Bagages, b.ID)
	})
	// return DB2BagageList(g_dbBagage).find(func(b *Bagage) bool {
	// 	return dry.StringListContains(c.Bagages, b.ID)
	// })
}

// func (c *Car) getID() string {
// 	return c.ID
// }
func (c *Car) equal(car *Car) bool {
	return c.ID == car.ID
}
func (c *Car) removeBagage(id string) {
	// c.Bagages = c.Bagages.remove(id)
	c.Bagages = dry.StringFilter(func(s string) bool {
		return s != id
	}, c.Bagages)
	if err := c.dbLink.bagages.delete(id); err != nil {
		DebugSysF("delete bagage error: %s", err)
	}
}
func (c *Car) addBagage(b *Bagage) error {
	if c.hasBagage(b.ID) {
		return errors.New("alreay exits")
	} else {
		b.CarID = c.ID
		c.Bagages = append(c.Bagages, b.ID)
		if err := c.dbLink.bagages.put(b.ID, b); err != nil {
			return err
		}
		return nil
	}
}
func (c *Car) hasBagage(id string) bool {
	// return c.Bagages.exists(id)
	return dry.StringListContains(c.Bagages, id)
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
func (cl CarList) ListName() string {
	return "Car List"
}
func (cl CarList) InfoList() (l []string) {
	for _, c := range cl {
		l = append(l, c.String())
	}
	return
}
