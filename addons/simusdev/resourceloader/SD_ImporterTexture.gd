extends SD_Importer
class_name SD_ImporterTexture

static func load(path) -> Texture2D:
	var image := Image.load_from_file(path)
	image.compress(Image.COMPRESS_BPTC)
	var texture := ImageTexture.create_from_image(image)
	return texture
