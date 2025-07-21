use godot::classes::input::MouseMode;
use godot::classes::{Node, CharacterBody3D, Input};
use godot::prelude::*;


#[derive(GodotClass)]
#[class(base=Node)]
pub struct PlayerMovement {
    base: Base<Node>,
    
    #[export]
    enabled: bool,
    #[export]
    player: Option<Gd<CharacterBody3D>>,

    //#[]

    #[export]
    move_speed: f32,
    #[export]
    jump_force: f32,
    #[export]
    key_left: StringName,
    #[export]
    key_right: StringName,
    #[export]
    key_backward: StringName,
    #[export]
    key_forward: StringName,
    #[export]
    key_jump: StringName,
    #[export]
    key_crouch: StringName,
    
}



#[godot_api]
impl INode for PlayerMovement {
    fn init(base: Base<Node>) -> Self {
        Self {
            base,
            player: None,
            enabled: bool::from(true),
            move_speed: f32::from(5.0),
            jump_force: f32::from(8.0),
            key_left: StringName::from("key_left"),
            key_right: StringName::from("key_right"),
            key_backward: StringName::from("key_backward"),
            key_forward: StringName::from("key_forward"),
            key_jump: StringName::from("key_jump"),
            key_crouch: StringName::from("key_crouch"),
        }
    }

    

    fn ready(&mut self,) {
        if !&self.base_mut().is_multiplayer_authority() {return}
        
        Input::singleton().set_mouse_mode(MouseMode::CAPTURED);
    }

    fn physics_process(&mut self, _delta: f64,) {
        self.set_enabled(self.base().is_multiplayer_authority());

        if !self.enabled {return}
        
        if let Some(player) = &self.player {
            let mut player: Gd<CharacterBody3D> = player.clone(); 
            let mut velocity: Vector3 = player.get_velocity();
            
            if player.is_on_floor() {
                if Input::singleton().is_action_just_pressed(&self.key_jump) {
                    velocity.y += &self.jump_force;
                }
            }

            let keys_dir: Vector2 = Input::singleton().get_vector(
                &self.key_left.clone(),
                &self.key_right.clone(),
                &self.key_forward.clone(),
                &self.key_backward.clone()
                );

            let direction = Vector3::new(keys_dir.x, 0.0, keys_dir.y);
            if direction != Vector3::ZERO {
                let direction = player.get_global_transform().basis * direction.normalized();
    
                velocity.x = direction.x * self.move_speed;
                velocity.z = direction.z * self.move_speed;
                
            }
            else {
                velocity.x = 0.0;
                velocity.z = 0.0;
            }

            player.set_velocity(velocity);
        }
    }
}

#[godot_api]
impl PlayerMovement {
    
}
