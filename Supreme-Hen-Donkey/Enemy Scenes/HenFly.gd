extends RigidBody2D

#export var SIGHT_RADIUS := 200
export var FLIGHT_SPEED := 400
export var is_flipped := false
export var rad := 350
export var despawn := false

onready var bottom_zone = $BottomZone

var attack_mode = false
var noticed_player = false
var despawn_timer = 90

var enabled := true
onready var dragCollider = $CollisionShape2D

var pref_scale

func _ready():
	$SightZone/CollisionShape2D.shape.radius = rad
	#$SightZone/CollisionShape2D.shape.set_radius(rad) 
	#$SightZone/CollisionShape2D.radius = rad
	pref_scale = scale
	
	#print(str($CollisionShape2D.shape.radius))


func _integrate_forces(state):
	
	#$SightZone/CollisionShape2D.shape.set_radius(rad) 
	scale = pref_scale
	
	if is_flipped:
		#scale = Vector2(-1,1)
		scale.x *= -abs(scale.x)
		#setScale(-1,1)
		#$AnimatedSprite.flip_h = true
		#self.rotation_degrees = 180
		#$AnimatedSprite.rotation_degrees = 180
		#pass
		
	




func _process(delta):
	if not enabled:
		return
	
	check_for_player()
		
	if attack_mode:
		
		$AnimatedSprite.animation = "Flying"
		$AnimatedSprite.speed_scale = 3
		gravity_scale = 0
	
	else:
		
		gravity_scale = 20
		$AnimatedSprite.speed_scale = 1
		$AnimatedSprite.animation = "Idle"
		#$AnimatedSprite.animation = "Flying"
	
	if linear_velocity.x > 0:
		$AnimatedSprite.flip_h = true
	elif linear_velocity.x < 0:
		$AnimatedSprite.flip_h = false


func check_for_player():
	
	var player_found = false
	
	for body in $SightZone.get_overlapping_bodies():
		
		if body is Player:
			
			player_found = true
			
			if not noticed_player and despawn:
				activate_self_destruct()
			
			attack_mode = true
			
			var dist = (body.global_position - self.global_position).normalized()
			
			#linear_velocity = dist * FLIGHT_SPEED
			#apply_central_impulse(dist * FLIGHT_SPEED)
			applied_force = dist * FLIGHT_SPEED
				
		if not body.get("noticed_player") == null:
			if body.noticed_player == true:
				activate_self_destruct()
				
				
	if not player_found:
		attack_mode = false
		linear_velocity *= 0.99
		#applied_force = Vector2(0,0)
		
		
		
func activate_self_destruct():
	
	if noticed_player:
		return false
	
	noticed_player = true
	$AnimatedSprite.self_modulate = Color(1, 0, 0)
	$AnimatedSprite.modulate = Color(1, 0, 0)
	
	var timer = Timer.new()
	self.add_child(timer)
	
	print("self-destruct... activated!")
	
	
	timer.connect("timeout", self, "queue_free")
	timer.set_wait_time(despawn_timer)
	timer.start()
