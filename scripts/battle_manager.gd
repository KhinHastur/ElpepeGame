extends Node

var player_team: Array = []
var enemy_team: Array = []

func _ready():
	player_team = $"../PlayerTeam".get_children().map(func(n): return n as Character)
	enemy_team = $"../EnemyTeam".get_children().map(func(n): return n as Character)
	print("Players: ", player_team)
	print("Enemies: ", enemy_team)
	run_player_turn()

func run_player_turn():
	for player in player_team:
		if player.current_hp <= 0:
			continue

		for enemy in enemy_team:
			if enemy.current_hp <= 0:
				continue

			await attack_sequence(player, enemy)

		if check_battle_end():
			return

	# after all players attacked, enemy turn
	run_enemy_turn()


func run_enemy_turn():
	for enemy in enemy_team:
		if enemy.current_hp <= 0:
			continue
		var targets = player_team.filter(func(p): return p.current_hp > 0)
		if targets.is_empty():
			return
		var target = targets[randi() % targets.size()]
		await attack_sequence(enemy, target)
		if check_battle_end():
			return
	run_player_turn()


func attack_sequence(attacker: Character, defender: Character):
	var original_pos = attacker.global_position  # ← global
	var direction = (defender.global_position - attacker.global_position).normalized()
	var attack_pos = defender.global_position - direction * 60  # ← global

	await attacker.slide_to(attack_pos)
	attacker.play_attack()
	await attacker.animation_done

	defender.take_damage(attacker.attack_power)

	await attacker.slide_back(original_pos)
	
func check_battle_end() -> bool:
	var all_enemies_dead = enemy_team.all(func(e): return e.current_hp <= 0)
	var all_players_dead = player_team.all(func(p): return p.current_hp <= 0)

	if all_enemies_dead:
		print("Players win!")
		return true

	if all_players_dead:
		print("Enemies win!")
		return true

	return false
