extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	resize_light()

func resize_light():
	await RenderingServer.frame_post_draw
	get_parent().texture = ImageTexture.create_from_image(get_texture().get_image())
