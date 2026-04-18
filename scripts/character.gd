class_name Character extends Node

@export var attack_power: int = 10
@export var max_hp: int = 100
var current_hp: int

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

signal animation_done  # battle_manager listens to this

func _ready():
	current_hp = max_hp
	anim.animation_finished.connect(_on_animation_finished)
	play_idle()

func play_idle():
	anim.play("idle")

func play_attack():
	anim.play("attack")

func play_death():
	anim.play("death")

func take_damage(amount: int):
	current_hp -= amount
	current_hp = max(current_hp, 0)
	print(current_hp)
	if current_hp <= 0:
		die()
	else:
		emit_signal("animation_done")
	
func slide_to(target_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
	await tween.finished

func slide_back(original_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_pos, 0.3)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_SINE)
	await tween.finished
	

func die():
	play_death()
	# optionally disable the character
	set_process(false)

func _on_animation_finished():
	if current_hp <= 0:
		return  # don't go back to idle if dead
	play_idle()
	emit_signal("animation_done")
