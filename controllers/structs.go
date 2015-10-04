package controllers

import (
// "fmt"
)

type UserList []*User

type User struct {
	Password string
	Email    string
	UserName string
	Cars     CarList
}

type CarList []*Car

type Car struct {
	ID, AddedTime, Note string
	Owner               string
	Bagages             BagageList `json:"-"`
	LatestPosition      *Positon
}

type BagageList []*Bagage

type Bagage struct {
	ID, CarID, AddedTime, Note string
}

type Positon struct {
	CarID     string
	Lat, Lng  float64
	TimeStamp string
}

type PositionList []*Positon
