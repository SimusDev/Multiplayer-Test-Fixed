extends Node

#rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality

func command_executed(command:SD_ConsoleCommand) -> void:
	var callable_name:String = command.get_code().split(".")[1]
	var callable = Callable(self, callable_name)
	
	
	if not has_method(callable_name):
		SimusDev.console.write_error("No.")
		return
	#if command.get_arguments().size() > callable.get_argument_count():
		#SimusDev.console.write_error("Expected %s arguments" % [callable.get_argument_count()])
		#return
	
	callable.call( command.get_arguments() )

func soft_shadow_filter_quality(args:Array) -> void:
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality", args[0])
	print(ProjectSettings.get_setting("rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality"))

func motion_blur_intensity(args:Array):
	ProjectSettings.set_setting("rendering/camera/motion_blur/motion_blur_intensity", args[0])
	print(ProjectSettings.get_setting("rendering/camera/motion_blur/motion_blur_intensity"))

func motion_blur_quality(args:Array):
	ProjectSettings.set_setting("rendering/camera/motion_blur/motion_blur_quality", args[0])
