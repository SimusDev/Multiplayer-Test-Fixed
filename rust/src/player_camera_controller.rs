use godot::classes::{Camera3D, Node, CharacterBody3D, InputEvent, InputEventMouseMotion};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Node)]

pub struct PlayerCameraController {
    base: Base<Node>,
    
    #[export]
    camera: Option<Gd<Camera3D>>,
    #[export]
    player: Option<Gd<CharacterBody3D>>,

    #[export]
    sensivity: f32,
}

#[godot_api]
impl INode for PlayerCameraController {
    fn init(base: Base<Node>) -> Self {
        Self {
            base,

            camera: None,
            player: None,

            sensivity: f32::from(1.0),
            }
        }
    
    // RUST

    fn input(&mut self, event: Gd<InputEvent>) {
        if let Some(player) = &self.player {
            if let Ok(mouse_motion) = event.clone().try_cast::<InputEventMouseMotion>() {
                let relative: Vector2 = mouse_motion.get_relative();
                let mut player: Gd<CharacterBody3D> = player.clone(); 
                
                if let Some(camera) = &mut self.camera {
                    player.rotate_y(relative.x as f32 * -(0.01 * &self.sensivity));
                    camera.rotate_x(relative.y as f32 * -(0.01 * &self.sensivity));
                }
            }
        }

    }



}

impl PlayerCameraController {

}