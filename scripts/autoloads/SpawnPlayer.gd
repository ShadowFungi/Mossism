extends Node

var rand = RandomNumberGenerator.new()
var reg = RegEx.new()

func spawn_player(player: PackedScene, spawns : Array = get_spawns()):
	if get_tree().get_nodes_in_group('player').size() < 1 :
		var player_instance = player.instantiate()
		randomize()
		reg.compile(".+(?<=player)")
		var reg_r
		if spawns.size() > 1:
			var spawn = spawns[rand.randi_range(0, spawns.size() - 1)]
			player_instance.global_position = spawn.get_global_position()
			reg_r = reg.search(String(spawn.to_string()))
		else:
			player_instance.global_position = spawns[0].get_global_position()
			reg_r = reg.search(String(spawns[0].to_string()))
		get_node("/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport").add_child.call_deferred(player_instance)
		prints(reg_r)
	
	#print(spawns.pick_random())
	#if Keyboard.total_players > 3:
	#	for player in Keyboard.ids:
	#		#print(Keyboard.ids[player])
	#		#print("player%s" % Keyboard.total_players)
	#		get_node(Keyboard.player_nodes[player]).global_position = get_node('/root/SplitScreen').find_child(reg_r.get_string()).global_position + Vector3(0, 4, 0)
	#		get_node(Keyboard.player_nodes[player]).rotate(Vector3.UP, deg_to_rad(get_node('/root/SplitScreen').find_child(reg_r.get_string()).properties.angle))
	#else:
	#	#print("node")
	#	get_node(Keyboard.player_nodes[0]).global_position = get_node('/root/SplitScreen').find_child(reg_r.get_string()).global_position + Vector3(0, 4, 0)
	#	get_node(Keyboard.player_nodes[0]).rotate(Vector3.UP, deg_to_rad(get_node('/root/SplitScreen').find_child(reg_r.get_string()).properties.angle))


func get_spawns() -> Array:
	var spawns = get_tree().get_nodes_in_group("player_spawn")
	var priority_spawn = get_tree().get_first_node_in_group("priority_player_spawner")
	var spawner_primary : Array = [priority_spawn]
	#print(spawns)
	
	#if Keyboard.total_players >= 2:
	#	return spawns
	return spawns
