extends CharacterBody2D

var speed = 30
var player_chase = false
var player = null

var health = 50
var player_in_attack_zone = false

var dying = false

func _ready():
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta):
	deal_with_damage()
	
	if dying == true:
		$AnimatedSprite2D.play("die")
	else:
		if player_chase:
			var direction = (player.position - position).normalized()
			position += direction * speed * delta

			if direction.x < 0:
				$AnimatedSprite2D.play("walk_side")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("walk_side")
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle_front")
		move_and_slide()
# we get the base of these 2 below functions when we connect the signal 
# to our enemy in the node tab of Area2DDetection
func _on_area_2d_detection_body_entered(body):
	player = body
	player_chase = true 

func enemy():
	pass

func _on_area_2d_detection_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		
func deal_with_damage():
	if player_in_attack_zone and Combat.player_current_attack == true:
		health = health - 20
		print("enemy health =", health)
		if health <= 0:
			dying = true
			$death_timer.start()
			
	



func _on_death_timer_timeout():
	$death_timer.stop()
	self.queue_free()
	
