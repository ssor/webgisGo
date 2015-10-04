package controllers

import (
	"fmt"
	// "github.com/astaxie/beego"
	// "errors"
	"time"
)

func init() {
	// fmt.Println("2006-01-02 00:00:00"[:10])
}

type positionPredictor func(*Positon) bool

func (p *Positon) String() string {
	return fmt.Sprintf("car(%s) %s (%f, %f)", p.CarID, p.TimeStamp, p.Lng, p.Lat)
}
func NewPosition(car string, lat, lng float64) *Positon {
	addedTime := time.Now().Format("2006-01-02 15:04:05")
	return &Positon{
		CarID:     car,
		Lat:       lat,
		Lng:       lng,
		TimeStamp: addedTime,
	}
}

func (pl PositionList) find(p positionPredictor) PositionList {
	return pl.findRecursive(p, PositionList{})
}
func (pl PositionList) findRecursive(p positionPredictor, list PositionList) PositionList {
	if len(pl) <= 0 {
		return list
	}
	if p(pl[0]) {
		list = append(list, pl[0])
	}
	return pl[1:].findRecursive(p, list)
}

// type CarIDTaggedPositionList map[string]PositionList

// func (tpl CarIDTaggedPositionList) getPointsInSpecialTime(carID, start, end string) PositionList {
// 	if list, ok := tpl[carID]; ok {
// 		return list.find(func(p *Positon) bool {
// 			return p.TimeStamp >= start && p.TimeStamp <= end
// 		})
// 	}
// 	return nil
// }

// func (tpl CarIDTaggedPositionList) getLatestPosition(carID string) *Positon {
// 	if list, ok := tpl[carID]; ok {
// 		if len(list) <= 0 {
// 			return nil
// 		} else {
// 			return list[len(list)-1]
// 		}
// 	}
// 	return nil
// }
// func (tpl CarIDTaggedPositionList) addPosition(pos *Positon) {
// 	if list, ok := tpl[pos.CarID]; ok {
// 		tpl[pos.CarID] = append(list, pos)
// 	} else {
// 		tpl[pos.CarID] = PositionList{pos}
// 	}
// }
// func (tpl CarIDTaggedPositionList) ListName() string {
// 	return "Positions"
// }
// func (tpl CarIDTaggedPositionList) InfoList() (l []string) {
// 	for key, value := range tpl {
// 		l = append(l, fmt.Sprintf("%s  count: %d last: %s", key, len(value), value[len(value)-1]))
// 	}
// 	return
// }
