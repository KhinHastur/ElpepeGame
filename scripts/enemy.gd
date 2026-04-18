class_name Enemy
extends Character
@export var char_name: String = "Enemy"

func attack(target: Character):
	play_attack()
	await animation_done
	target.take_damage(attack_power)
