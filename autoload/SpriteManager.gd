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
		print("SpriteManager: Config file not found, creating default")
		create_default_sprite_config()
		return
	
	var file = FileAccess.open(SPRITE_CONFIG_PATH, FileAccess.READ)
	if not file:
		print("SpriteManager Error: Could not open sprite config file")
		create_default_sprite_config()
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	# Validate JSON text
	if json_text.is_empty():
		print("SpriteManager Error: Empty config file")
		create_default_sprite_config()
		return
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		print("SpriteManager Error: JSON parse failed at line %d: %s" % [json.get_error_line(), json.get_error_message()])
		create_default_sprite_config()
		return
	
	if not json.data is Dictionary:
		print("SpriteManager Error: Config file root is not a dictionary")
		create_default_sprite_config()
		return
	
	# Validate config structure
	if not _validate_sprite_config(json.data):
		print("SpriteManager Error: Invalid config structure")
		create_default_sprite_config()
		return
	
	sprite_configs = json.data
	print("SpriteManager: Loaded %d sprite configurations" % sprite_configs.size())

## Validate sprite configuration structure
func _validate_sprite_config(config: Dictionary) -> bool:
	for character_name in config:
		var char_config = config[character_name]
		if not char_config is Dictionary:
			print("SpriteManager Error: Invalid character config for '%s'" % character_name)
			return false
		
		# Check required fields
		var required_fields = ["path", "frame_size", "animations", "scale", "offset"]
		for field in required_fields:
			if not field in char_config:
				print("SpriteManager Error: Missing field '%s' in character '%s'" % [field, character_name])
				return false
		
		# Validate frame_size
		if not char_config.frame_size is Dictionary or not "width" in char_config.frame_size or not "height" in char_config.frame_size:
			print("SpriteManager Error: Invalid frame_size for character '%s'" % character_name)
			return false
		
		# Validate animations
		if not char_config.animations is Dictionary:
			print("SpriteManager Error: Invalid animations for character '%s'" % character_name)
			return false
	
	return true

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
	var frames = _create_sprite_frames(config, texture)
	if not frames:
		print("SpriteManager Error: Failed to create frames for '%s'" % character_name)
		return null
	
	# Setup sprite properties
	_setup_sprite_properties(sprite, frames, config)
	
	# Connect signals and store reference
	_finalize_sprite_setup(sprite, character_name)
	
	print("SpriteManager: Created sprite for '%s'" % character_name)
	return sprite

## Create SpriteFrames resource from configuration and texture
func _create_sprite_frames(config: Dictionary, texture: Texture2D) -> SpriteFrames:
	var frames = SpriteFrames.new()
	
	# Calculate frame dimensions
	var frame_dimensions = _calculate_frame_dimensions(config, texture)
	
	# Create animations
	for anim_name in config.animations:
		if not _create_animation(frames, anim_name, config.animations[anim_name], texture, frame_dimensions):
			print("SpriteManager Warning: Failed to create animation '%s'" % anim_name)
	
	return frames

## Calculate frame dimensions and layout
func _calculate_frame_dimensions(config: Dictionary, texture: Texture2D) -> Dictionary:
	var frame_width = config.frame_size.width
	var frame_height = config.frame_size.height
	var texture_width = texture.get_width()
	var texture_height = texture.get_height()
	var cols = texture_width / frame_width
	var rows = texture_height / frame_height
	
	return {
		"width": frame_width,
		"height": frame_height,
		"cols": cols,
		"rows": rows
	}

## Create individual animation from configuration
func _create_animation(frames: SpriteFrames, anim_name: String, anim_config: Dictionary, texture: Texture2D, dimensions: Dictionary) -> bool:
	frames.add_animation(anim_name)
	frames.set_animation_loop(anim_name, anim_config.loop)
	frames.set_animation_speed(anim_name, anim_config.fps)
	
	# Add frames to animation
	for frame_index in anim_config.frames:
		var atlas_texture = _create_atlas_texture(texture, frame_index, dimensions)
		if atlas_texture:
			frames.add_frame(anim_name, atlas_texture)
		else:
			return false
	
	return true

## Create atlas texture for a specific frame
func _create_atlas_texture(texture: Texture2D, frame_index: int, dimensions: Dictionary) -> AtlasTexture:
	var x = (frame_index % dimensions.cols) * dimensions.width
	var y = (frame_index / dimensions.cols) * dimensions.height
	
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = Rect2(x, y, dimensions.width, dimensions.height)
	
	return atlas_texture

## Setup sprite properties from configuration
func _setup_sprite_properties(sprite: AnimatedSprite2D, frames: SpriteFrames, config: Dictionary) -> void:
	sprite.sprite_frames = frames
	sprite.animation = "idle"
	sprite.scale = Vector2(config.scale, config.scale)
	sprite.offset = Vector2(config.offset.x, config.offset.y)

## Finalize sprite setup with signals and storage
func _finalize_sprite_setup(sprite: AnimatedSprite2D, character_name: String) -> void:
	# Connect signals
	sprite.animation_finished.connect(_on_sprite_animation_finished.bind(character_name))
	
	# Store reference
	sprite_instances[character_name] = sprite

## Load texture for a character
func load_texture(character_name: String) -> Texture2D:
	if character_name in loaded_textures:
		return loaded_textures[character_name]
	
	if not character_name in sprite_configs:
		return null
	
	var config = sprite_configs[character_name]
	
	# Sanitize path to prevent directory traversal
	var safe_path = config.path.replace("../", "").replace("..\\", "")
	var texture_path = SPRITES_BASE_PATH + safe_path
	
	# Ensure path is within sprites directory
	if not texture_path.begins_with(SPRITES_BASE_PATH):
		print("SpriteManager Error: Invalid path detected: %s" % config.path)
		var placeholder = create_placeholder_texture(character_name)
		loaded_textures[character_name] = placeholder
		return placeholder
	
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