extends Node

signal level_selected(level_meta: LevelMeta)

signal village_pillaged(village: Village)
signal villager_spawned(villager: Villager)
signal villager_head_moved()
signal update_score_ui()

signal win_conditions_met()
signal player_died()
signal game_over()
