use godot::classes::{CharacterBody3D, Node};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Node)]

pub struct PlayerPhysics {
    base: Base<Node>,
    
    #[export]
    player: Option<Gd<CharacterBody3D>>,

    #[export]
    gravity: f64,
}

#[godot_api]
impl INode for PlayerPhysics {
    fn init(base: Base<Node>) -> Self {
        Self {
            base,

            player: None,
            gravity: f64::from(9.8),
        }
    }


    fn physics_process(&mut self, delta: f64,) {
        if let Some(player) = &self.player {
            let mut player: Gd<CharacterBody3D> = player.clone(); 
            let mut velocity: Vector3 = player.get_velocity();
            
            if !player.is_on_floor() {
                velocity.y -= (self.gravity * delta) as f32;
            }
            
            player.set_velocity(velocity);
            player.move_and_slide();
        }
    }
}

impl PlayerPhysics {

}