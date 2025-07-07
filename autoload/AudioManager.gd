extends Node

signal audio_finished(sound_name: String)

var audio_players: Dictionary = {}
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []

const MAX_SFX_PLAYERS = 8
const AUDIO_BASE_PATH = "res://audio/"

var audio_config: Dictionary = {
	"music": {
		"hub_theme": "music/hub_ambient.ogg",
		"battle_theme": "music/battle_intense.ogg",
		"victory_theme": "music/victory_celebration.ogg",
		"boss_theme": "music/boss_psychedelic.ogg",
		"wedding_theme": "music/wedding_march.ogg"
	},
	"sfx": {
		"menu_select": "sfx/menu_select.wav",
		"menu_confirm": "sfx/menu_confirm.wav",
		"player_footstep": "sfx/footstep.wav",
		"level_unlock": "sfx/level_unlock.wav",
		"glen_confusion": "sfx/glen_confused.wav",
		"explosion": "sfx/explosion.wav",
		"camera_flash": "sfx/camera_flash.wav",
		"drumstick_hit": "sfx/drumstick_hit.wav",
		"alien_defeated": "sfx/alien_defeated.wav",
		"acids_joe_laugh": "sfx/acids_joe_laugh.wav"
	}
}

func _ready():
	print("AudioManager: Audio manager initialized")
	setup_audio_players()

func setup_audio_players():
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"
	add_child(music_player)
	
	# Create SFX players pool
	for i in range(MAX_SFX_PLAYERS):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer%d" % i
		sfx_player.bus = "SFX"
		sfx_players.append(sfx_player)
		add_child(sfx_player)
	
	print("AudioManager: Created %d SFX players" % MAX_SFX_PLAYERS)

func play_music(music_name: String, loop: bool = true, fade_in: bool = true):
	if music_name not in audio_config.music:
		print("AudioManager: Music not found: %s" % music_name)
		return
	
	var music_path = AUDIO_BASE_PATH + audio_config.music[music_name]
	
	if not FileAccess.file_exists(music_path):
		print("AudioManager: Music file not found: %s" % music_path)
		return
	
	var stream = load(music_path)
	if stream:
		music_player.stream = stream
		music_player.play()
		print("AudioManager: Playing music: %s" % music_name)
		
		if fade_in:
			fade_in_music()
	else:
		print("AudioManager: Failed to load music: %s" % music_path)

func stop_music(fade_out: bool = true):
	if music_player.playing:
		if fade_out:
			fade_out_music()
		else:
			music_player.stop()
		print("AudioManager: Music stopped")

func play_sfx(sfx_name: String, volume: float = 1.0):
	if sfx_name not in audio_config.sfx:
		print("AudioManager: SFX not found: %s" % sfx_name)
		return
	
	var sfx_path = AUDIO_BASE_PATH + audio_config.sfx[sfx_name]
	
	if not FileAccess.file_exists(sfx_path):
		print("AudioManager: SFX file not found: %s" % sfx_path)
		return
	
	# Find available SFX player
	var available_player = get_available_sfx_player()
	if not available_player:
		print("AudioManager: No available SFX players")
		return
	
	var stream = load(sfx_path)
	if stream:
		available_player.stream = stream
		available_player.volume_db = linear_to_db(volume)
		available_player.play()
		print("AudioManager: Playing SFX: %s" % sfx_name)
	else:
		print("AudioManager: Failed to load SFX: %s" % sfx_path)

func get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null

func set_master_volume(volume: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(volume))

func set_music_volume(volume: float):
	var music_bus = AudioServer.get_bus_index("Music")
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(volume))

func set_sfx_volume(volume: float):
	var sfx_bus = AudioServer.get_bus_index("SFX")
	if sfx_bus != -1:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(volume))

func fade_in_music(duration: float = 1.0):
	var tween = create_tween()
	music_player.volume_db = -80
	tween.tween_property(music_player, "volume_db", 0, duration)

func fade_out_music(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)
	tween.tween_callback(music_player.stop)

# Character-specific audio functions
func play_character_sound(character_name: String, action: String):
	var sound_name = "%s_%s" % [character_name, action]
	
	match character_name:
		"mark":
			match action:
				"attack":
					play_sfx("drumstick_hit")
				"footstep":
					play_sfx("player_footstep")
		"jenny":
			match action:
				"attack":
					play_sfx("camera_flash")
				"footstep":
					play_sfx("player_footstep")
		"glen":
			match action:
				"confused":
					play_sfx("glen_confusion")
				"accident":
					play_sfx("explosion", 0.5)
		"acids_joe":
			match action:
				"laugh":
					play_sfx("acids_joe_laugh")
				"defeat":
					play_sfx("alien_defeated")

# Level-specific audio
func play_level_music(level_name: String):
	match level_name:
		"hub":
			play_music("hub_theme")
		"glen_bingo":
			play_music("hub_theme")
		"beat_em_up":
			play_music("battle_theme")
		"wedding_adventure":
			play_music("battle_theme")
		"boss_fight":
			play_music("boss_theme")
		"wedding_ceremony":
			play_music("wedding_theme")

# Create placeholder audio files if they don't exist
func create_placeholder_audio():
	print("AudioManager: Creating placeholder audio files")
	
	# This would create simple generated audio files
	# For now, just log what would be created
	for category in audio_config:
		for sound_name in audio_config[category]:
			var path = AUDIO_BASE_PATH + audio_config[category][sound_name]
			if not FileAccess.file_exists(path):
				print("AudioManager: Would create placeholder: %s" % path)

func linear_to_db(linear: float) -> float:
	if linear <= 0:
		return -80
	return 20 * log(linear) / log(10)

# Debug functions
func list_audio_files():
	print("=== AUDIO CONFIG ===")
	for category in audio_config:
		print("%s:" % category.to_upper())
		for sound_name in audio_config[category]:
			print("  %s: %s" % [sound_name, audio_config[category][sound_name]])

func test_all_sfx():
	print("AudioManager: Testing all SFX")
	for sfx_name in audio_config.sfx:
		await get_tree().create_timer(0.5).timeout
		play_sfx(sfx_name)
		print("  Testing: %s" % sfx_name)