mod player_movement;
mod player_physics;
mod player_camera_controller;

use godot::prelude::*;

pub struct RustExtension;

#[gdextension]
unsafe impl ExtensionLibrary for RustExtension {}
