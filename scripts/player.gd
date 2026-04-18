class_name Player
extends Character
@export var char_name: String = "Player"

func attack(target: Character):
	play_attack()
	await animation_done
	target.take_damage(attack_power)
