@tool
extends Path3D


@export_category("vine-whip-geometry")
@export var mmi_separation: float = 1.0:
	set(value):
		mmi_separation = value
		is_dirty = true
@export var separation_distance: float = 1.0:
	set(value):
		separation_distance = value
		is_dirty = true
@export var offset_divede: float = 2.0:
	set(value):
		offset_divede = value
		is_dirty = true
@export var is_dirty: bool = false
@export var is_paused: bool = false

var original_path: PackedVector3Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_path = curve.get_baked_points()
	#print(curve.get_baked_points())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dirty and is_paused == false:
		_update_multimesh()
		is_dirty = false


func _update_multimesh():
	var path_length: float = curve.get_baked_length()
	var count: int = floori(path_length / separation_distance)
	
	var offset: float = separation_distance / offset_divede
	
	for child in get_child_count(false):
		if get_child(child) is MultiMeshInstance3D:
			var mm: MultiMesh = get_child(child).multimesh
			mm.instance_count = count
			#print(child)
			for i in range(0, count):
				randomize()
				var curve_distance: float
				if child == 0:
					curve_distance = (offset + separation_distance * (i)) * (2)
				else:
					curve_distance = (offset + separation_distance * (i)) * ((child + 1) * 2)
				var new_position: Vector3 = curve.sample_baked(curve_distance - 0.2, true)
				
				var new_basis: Basis = Basis()
				
				var up: Vector3 = curve.sample_baked_up_vector(curve_distance, true)
				var forward: Vector3 = new_position.direction_to(curve.sample_baked(curve_distance, true))
				
				new_basis.y = up
				new_basis.x = forward.cross(up).normalized()
				new_basis.z = -forward
				
				#print(forward)
				#new_basis = new_basis * 1.06
				var new_transform = Transform3D(new_basis, new_position)
				if forward.is_normalized() == false:
					forward = Vector3.FORWARD.normalized()
				new_transform.basis = new_basis.rotated(-forward, snapped(randi_range(0, 360), deg_to_rad(60)))
				#new_transform = new_transform.translated(Vector3(0, 0, child))
				#new_transform.looking_at(new_position / 2)
				
				new_basis = new_basis.scaled(Vector3(0.5, 0.5, 0.5))
				
				
				#if i >= 1:
				#	new_transform = new_transform.looking_at(mm.get_instance_transform(i - 1).origin)
				#var new_transform = curve.sample_baked_with_rotation(curve_distance, false)
				mm.set_instance_transform(i, new_transform)
				#if i == 0:
					#new_basis = new_basis.rotated(up, position.angle_to(get_node('../WhipHandleMI').get_position()))
					
				#if i >= 1 and i <= count:
				#	mm.set_instance_transform(i, mm.get_instance_transform(i).looking_at(mm.get_instance_transform(i - 1).origin.direction_to(Vector3(mm.get_instance_transform(i).origin.x / 2, mm.get_instance_transform(i).origin.y / 2, mm.get_instance_transform(i).origin.z / 2)), forward.cross(up).normalized()))


func create_path_to_point(end_point: Vector3, start_point: Vector3 = Vector3.ZERO):
	curve.clear_points()
	curve.add_point(start_point)
	curve.add_point(end_point)


func _on_curve_changed() -> void:
	is_dirty = true
