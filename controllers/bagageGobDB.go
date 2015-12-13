package controllers

import (
	"github.com/ssor/GobDB"
	// "GobDB"
	"errors"
)

type BagageGobDB struct {
	DB *GobDB.DB
}

func NewBagageGobDB() *BagageGobDB {
	return &BagageGobDB{
		DB: GobDB.NewDB("bagages", func() interface{} { var b Bagage; return &b }),
	}
}
func (db *BagageGobDB) init() error {
	_, err := db.DB.Init()
	return err
}
func (db *BagageGobDB) addBagage(b *Bagage) error {
	return db.update(b.ID, b)
}
func (db *BagageGobDB) update(id string, b *Bagage) error {
	err := db.delete(id)
	if err != nil {
		return err
	}
	return db.put(id, b)
}

func (db *BagageGobDB) put(id string, b *Bagage) error {
	return db.DB.Put(id, b)
}
func (db *BagageGobDB) delete(id string) error {
	return db.DB.Delete(id)
}
func (db *BagageGobDB) find(p bagagePredicotr) BagageList {
	list := BagageList{}
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*Bagage)) {
			list = append(list, v.(*Bagage))
		}
	}
	return list
}
func (db *BagageGobDB) findOne(p bagagePredicotr) *Bagage {
	for _, v := range db.DB.ObjectsMap {
		if p(v.(*Bagage)) {
			return v.(*Bagage)
		}
	}
	return nil
}
func (db *BagageGobDB) forOne(f func(*Bagage), p bagagePredicotr) (*Bagage, error) {
	if b := db.findOne(p); b != nil {
		f(b)
		if err := db.delete(b.ID); err != nil {
			return nil, err
		}
		if err := db.put(b.ID, b); err != nil {
			return nil, err
		}
		return b, nil
	} else {
		return nil, errors.New("Not Found")
	}
}
func (db *BagageGobDB) Has(id string) bool {
	// return db.(*GobDB.DB).Has(id)
	return db.DB.Has(id)
}
