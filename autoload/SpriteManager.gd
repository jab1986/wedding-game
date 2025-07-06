extends Node
## Centralized sprite management system for the wedding game
## Handles sprite loading, configuration, and animation management

signal sprite_loaded(sprite_name: String, texture: Texture2D)
signal sprite_animation_finished(sprite_name: String, animation: String)

const SPRITE_CONFIG_PATH = "res://data/sprite_config.json"
const SPRITES_BASE_PATH = "res://sprites/"

var sprite_configs: Dictionary = {}
var loaded_textures: Dictionary = {}
var sprite_instances: Dictionary = {}

func _ready():
	load_sprite_configurations()

## Load sprite configurations from JSON file
func load_sprite_configurations() -> void:
	if not FileAccess.file_exists(SPRITE_CONFIG_PATH):
		create_default_sprite_config()
	
	var file = FileAccess.open(SPRITE_CONFIG_PATH, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		
		if parse_result == OK:
			sprite_configs = json.data
			print("SpriteManager: Loaded %d sprite configurations" % sprite_configs.size())
		else:
			print("SpriteManager Error: Failed to parse sprite config JSON")
			create_default_sprite_config()
	else:
		print("SpriteManager Error: Could not open sprite config file")
		create_default_sprite_config()

## Create default sprite configuration for wedding game characters
func create_default_sprite_config() -> void:
	sprite_configs = {
		"mark": {
			"path": "characters/mark.png",
			"frame_size": {"width": 64, "height": 64},
			"animations": {
				"idle": {"frames": [0, 1, 2, 1], "fps": 4, "loop": true},
				"walk": {"frames": [3, 4, 5, 4], "fps": 8, "loop": true},
				"attack": {"frames": [6, 7, 8], "fps": 12, "loop": false},
				"drumstick_attack": {"frames": [9, 10, 11, 10], "fps": 10, "loop": false}
			},
			"scale": 1.0,
			"offset": {"x": 0, "y": 0}
		},
		"jenny": {
			"path": "characters/jenny.png", 
			"frame_size": {"width": 64, "height": 64},
			"animations": {
				"idle": {"frames": [0, 1, 2, 1], "fps": 3, "loop": true},
				"walk": {"frames": [3, 4, 5, 4], "fps": 8, "loop": true},
				"photo": {"frames": [6, 7, 8, 7], "fps": 6, "loop": false},
				"camera_bomb": {"frames": [9, 10, 11, 12], "fps": 15, "loop": false}
			},
			"scale": 1.0,
			"offset": {"x": 0, "y": 0}
		},
		"glen": {
			"path": "characters/glen.png",
			"frame_size": {"width": 64, "height": 64}, 
			"animations": {
				"idle": {"frames": [0, 1, 0, 2], "fps": 2, "loop": true},
				"walk": {"frames": [3, 4, 5, 4], "fps": 6, "loop": true},
				"confused": {"frames": [6, 7, 8, 7, 6], "fps": 4, "loop": true},
				"accident": {"frames": [9, 10, 11, 12, 11, 10], "fps": 8, "loop": false}
			},
			"scale": 1.0,
			"offset": {"x": 0, "y": 0}
		},
		"quinn": {
			"path": "characters/quinn.png",
			"frame_size": {"width": 64, "height": 64},
			"animations": {
				"idle": {"frames": [0, 1], "fps": 2, "loop": true},
				"walk": {"frames": [2, 3, 4, 3], "fps": 8, "loop": true},
				"organize": {"frames": [5, 6, 7, 6], "fps": 6, "loop": true},
				"fix_chaos": {"frames": [8, 9, 10, 11], "fps": 10, "loop": false}
			},
			"scale": 1.0,
			"offset": {"x": 0, "y": 0}
		},
		"jack": {
			"path": "characters/jack.png",
			"frame_size": {"width": 64, "height": 64},
			"animations": {
				"idle": {"frames": [0, 1, 2, 1], "fps": 3, "loop": true},
				"walk": {"frames": [3, 4, 5, 4], "fps": 7, "loop": true},
				"coffee": {"frames": [6, 7, 8, 7], "fps": 5, "loop": false},
				"hipster_pose": {"frames": [9, 10, 11], "fps": 4, "loop": false}
			},
			"scale": 1.0,
			"offset": {"x": 0, "y": 0}
		},
		"acids_joe": {
			"path": "characters/acids_joe.png",
			"frame_size": {"width": 96, "height": 96},
			"animations": {
				"idle": {"frames": [0, 1, 2, 3, 2, 1], "fps": 6, "loop": true},
				"walk": {"frames": [4, 5, 6, 7], "fps": 8, "loop": true},
				"psychedelic_attack": {"frames": [8, 9, 10, 11, 12], "fps": 12, "loop": false},
				"boss_rage": {"frames": [13, 14, 15, 16, 15, 14], "fps": 10, "loop": true},
				"defeat": {"frames": [17, 18, 19, 20], "fps": 4, "loop": false}
			},
			"scale": 1.5,
			"offset": {"x": 0, "y": -16}
		}
	}
	
	save_sprite_configurations()
	print("SpriteManager: Created default sprite configurations")

## Save current sprite configurations to file
func save_sprite_configurations() -> void:
	var file = FileAccess.open(SPRITE_CONFIG_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(sprite_configs, "\t")
		file.store_string(json_string)
		file.close()
		print("SpriteManager: Saved sprite configurations")

## Create a sprite instance for a character
func create_sprite(character_name: String) -> AnimatedSprite2D:
	if not character_name in sprite_configs:
		print("SpriteManager Error: No configuration for character '%s'" % character_name)
		return null
	
	var config = sprite_configs[character_name]
	var sprite = AnimatedSprite2D.new()
	
	# Load texture
	var texture = load_texture(character_name)
	if not texture:
		print("SpriteManager Error: Failed to load texture for '%s'" % character_name)
		return null
	
	# Create SpriteFrames resource
	var frames = SpriteFrames.new()
	
	# Calculate frame dimensions
	var frame_width = config.frame_size.width
	var frame_height = config.frame_size.height
	var texture_width = texture.get_width()
	var texture_height = texture.get_height()
	var cols = texture_width / frame_width
	var rows = texture_height / frame_height
	
	# Create animations
	for anim_name in config.animations:
		var anim_config = config.animations[anim_name]
		frames.add_animation(anim_name)
		frames.set_animation_loop(anim_name, anim_config.loop)
		frames.set_animation_speed(anim_name, anim_config.fps)
		
		# Add frames to animation
		for frame_index in anim_config.frames:
			var x = (frame_index % cols) * frame_width
			var y = (frame_index / cols) * frame_height
			
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = texture
			atlas_texture.region = Rect2(x, y, frame_width, frame_height)
			
			frames.add_frame(anim_name, atlas_texture)
	
	# Setup sprite
	sprite.sprite_frames = frames
	sprite.animation = "idle"
	sprite.scale = Vector2(config.scale, config.scale)
	sprite.offset = Vector2(config.offset.x, config.offset.y)
	
	# Connect signals
	sprite.animation_finished.connect(_on_sprite_animation_finished.bind(character_name))
	
	# Store reference
	sprite_instances[character_name] = sprite
	
	print("SpriteManager: Created sprite for '%s'" % character_name)
	return sprite

## Load texture for a character
func load_texture(character_name: String) -> Texture2D:
	if character_name in loaded_textures:
		return loaded_textures[character_name]
	
	if not character_name in sprite_configs:
		return null
	
	var config = sprite_configs[character_name]
	var texture_path = SPRITES_BASE_PATH + config.path
	
	if not FileAccess.file_exists(texture_path):
		print("SpriteManager Warning: Texture file not found: %s" % texture_path)
		# Create placeholder texture
		var placeholder = create_placeholder_texture(character_name)
		loaded_textures[character_name] = placeholder
		return placeholder
	
	var texture = load(texture_path) as Texture2D
	if texture:
		loaded_textures[character_name] = texture
		sprite_loaded.emit(character_name, texture)
		return texture
	
	print("SpriteManager Error: Failed to load texture from %s" % texture_path)
	return null

## Create a placeholder texture for missing sprites
func create_placeholder_texture(character_name: String) -> ImageTexture:
	var config = sprite_configs[character_name]
	var width = config.frame_size.width
	var height = config.frame_size.height
	
	# Create colored placeholder based on character
	var color: Color
	match character_name:
		"mark":
			color = Color.RED
		"jenny": 
			color = Color.PINK
		"glen":
			color = Color.BROWN
		"quinn":
			color = Color.BLUE
		"jack":
			color = Color.GREEN
		"acids_joe":
			color = Color.PURPLE
		_:
			color = Color.GRAY
	
	var image = Image.create(width * 4, height * 3, false, Image.FORMAT_RGB8)
	image.fill(color)
	
	# Add simple pattern for different frames
	for i in range(12):
		var x = (i % 4) * width
		var y = (i / 4) * height
		var frame_rect = Rect2i(x + 4, y + 4, width - 8, height - 8)
		image.fill_rect(frame_rect, color.lightened(0.3))
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	print("SpriteManager: Created placeholder texture for '%s'" % character_name)
	return texture

## Get sprite configuration for a character
func get_sprite_config(character_name: String) -> Dictionary:
	if character_name in sprite_configs:
		return sprite_configs[character_name]
	return {}

## Update sprite configuration
func update_sprite_config(character_name: String, config: Dictionary) -> void:
	sprite_configs[character_name] = config
	save_sprite_configurations()

## Get sprite instance
func get_sprite_instance(character_name: String) -> AnimatedSprite2D:
	if character_name in sprite_instances:
		return sprite_instances[character_name]
	return null

## Preload all character textures
func preload_all_textures() -> void:
	for character_name in sprite_configs:
		load_texture(character_name)
	print("SpriteManager: Preloaded all textures")

## Animation helpers
func play_animation(character_name: String, animation: String) -> bool:
	var sprite = get_sprite_instance(character_name)
	if sprite and sprite.sprite_frames.has_animation(animation):
		sprite.play(animation)
		return true
	return false

func stop_animation(character_name: String) -> void:
	var sprite = get_sprite_instance(character_name)
	if sprite:
		sprite.stop()

func _on_sprite_animation_finished(character_name: String) -> void:
	var sprite = get_sprite_instance(character_name)
	if sprite:
		sprite_animation_finished.emit(character_name, sprite.animation)

## Debug helpers
func list_all_characters() -> Array:
	return sprite_configs.keys()

func print_character_info(character_name: String) -> void:
	if character_name in sprite_configs:
		var config = sprite_configs[character_name]
		print("=== Character: %s ===" % character_name)
		print("Path: %s" % config.path)
		print("Frame Size: %dx%d" % [config.frame_size.width, config.frame_size.height])
		print("Scale: %s" % config.scale)
		print("Animations: %s" % config.animations.keys())
	else:
		print("Character '%s' not found" % character_name)