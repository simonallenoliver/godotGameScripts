extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 500
var player_alive = true

var pray_ip = false

const speed = 160.0
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$Music.play()

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	pray()
				
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("pray"):
		$AnimatedSprite2D.animation = "pray"
		velocity.y = 0
		velocity.x = 0
	else:
		velocity.x = 0
		velocity.y = 0
		play_anim(0)
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
	
	
func player():
	pass

func _on_area_2d_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_area_2d_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true # Replace with function body.

func pray():
	if Input.is_action_just_pressed("pray"):
		Combat.player_current_attack = true
		pray_ip = true
		$AnimatedSprite2D.play("pray")
		$deal_attack_timer.start()
		$choir.play()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Combat.player_current_attack = false
	pray_ip = false  

func super_pray():
	if Input.is_action_just_pressed("superpray"):
		$AnimatedSprite2D.play("pray")
		$super_pray_timer.start()
		

func _on_super_pray_timeout():
	$super_pray_timer.stop()
	Combat.player_super_pray = true
