extends SubViewport
class_name SD_SubViewport

func make_screenshot(path: String) -> void:
	var image: Image = get_texture().get_image()
	image.save_png(path + ".png")
