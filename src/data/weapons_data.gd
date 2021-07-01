extends Node

var singleShot = {
	"name": "Single Shot", "bullet_scene": "SingleShot", "bullet_count": 1, "fire_rate": 0.5
}

var doubleShot = {
	"name": "Double Shot", "bullet_scene": "SingleShot", "bullet_count": 2, "fire_rate": 0.5
}

var quadShot = {
	"name": "Quad Shot", "bullet_scene": "SingleShot", "bullet_count": 4, "fire_rate": 0.2
}

var weapons = {"Single Shot": singleShot, "Double Shot": doubleShot, "Quad Shot": quadShot}
