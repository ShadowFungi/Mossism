extends Node


var total_controllers : Array
var ids : Dictionary = {
	"players":{}
	}
var num : int
var input_map : Dictionary = {
	"player-{n}_forward".format({"n":num}): Vector2.RIGHT,
	"player-{n}_back".format({"n":num}): Vector2.LEFT,
	"player-{n}_strafe_left".format({"n":num}): Vector2.UP,
	"player-{n}_strafe_right".format({"n":num}): Vector2.DOWN,
}
