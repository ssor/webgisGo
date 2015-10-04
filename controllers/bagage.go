package controllers

import (
	// "fmt"
	"errors"
	"time"
)

type bagagePredicotr func(*Bagage) bool

func NewBagage(id, note string) *Bagage {
	addedTime := time.Now().Format("2006-01-02 15:04:05")
	return &Bagage{
		ID:        id,
		AddedTime: addedTime,
		Note:      note,
		// id, addedTime, note,
		// id, carID, addedTime, note,
	}
}

func (bl BagageList) findOne(p bagagePredicotr) *Bagage {
	if len(bl) <= 0 {
		return nil
	}
	if p(bl[0]) {
		return bl[0]
	} else {
		return bl[1:].findOne(p)
	}
}

func (bl BagageList) exists(id string) bool {
	return bl.findOne(func(b *Bagage) bool { return b.ID == id }) != nil
}
func (bl BagageList) remove(id string) BagageList {
	return bl.removeRecursive(func(b *Bagage) bool { return b.ID == id }, BagageList{})
}
func (bl BagageList) forOne(f func(*Bagage), p bagagePredicotr) error {
	if u := bl.findOne(p); u != nil {
		f(u)
	} else {
		return errors.New("Not Found")
	}
	return nil
}

func (bl BagageList) find(f bagagePredicotr) BagageList {
	return bl.findRecursive(f, BagageList{})
}
func (bl BagageList) findRecursive(f bagagePredicotr, list BagageList) BagageList {
	if len(bl) <= 0 {
		return list
	}
	if f(bl[0]) {
		list = append(list, bl[0])
	}
	return bl[1:].findRecursive(f, list)
}
func (bl BagageList) removeRecursive(f bagagePredicotr, list BagageList) BagageList {
	if len(bl) <= 0 {
		return list
	}
	if f(bl[0]) {
		return append(list, bl[1:]...)
	} else {
		return bl[1:].removeRecursive(f, append(list, bl[0]))
	}
}
