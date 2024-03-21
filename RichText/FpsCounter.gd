extends RichTextLabel

func _process(_delta: float) -> void:
	text = str("FPS:",Engine.get_frames_per_second())
