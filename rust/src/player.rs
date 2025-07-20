use godot::classes::{CharacterBody2D, ICharacterBody2D, Input, MultiplayerApi};
use godot::prelude::*;


#[derive(GodotClass)]
#[class(base=CharacterBody2D)]
pub struct Test {
    base: Base<CharacterBody2D>,
    
    #[export]
    enabled: bool,

    //#[]

    #[export]
    move_speed: f64,
    #[export]
    key_left: StringName,
    #[export]
    key_right: StringName,
    #[export]
    key_backward: StringName,
    #[export]
    key_forward: StringName,
    
    move_direction: Vector2,
}



#[godot_api]
impl ICharacterBody2D for Test {
    fn init(base: Base<CharacterBody2D>) -> Self {
        Self {
            base,
            enabled: bool::from(true),
            move_speed: f64::from(5.0),
            key_left: StringName::from("key_left"),
            key_right: StringName::from("key_right"),
            key_backward: StringName::from("key_backward"),
            key_forward: StringName::from("key_forward"),
            move_direction: Vector2::ZERO,
        }
    }

    fn ready(&mut self,) {
        
    }

    fn physics_process(&mut self, _delta: f64,) {
        if !self.enabled {return}

        self.move_direction = Input::singleton().get_vector(
            &self.key_left.clone(),
            &self.key_right.clone(),
            &self.key_forward.clone(),
            &self.key_backward.clone()
            );
        
        let velocity = self.move_direction * self.move_speed as f32;
        self.base_mut().set_velocity(velocity);
        self.base_mut().move_and_slide();
    }
}

#[godot_api]
impl Test {
    #[rpc]
    fn sync_transform(&mut self, new_transform:Transform2D) {
        self.base_mut().set_transform(new_transform);
    }
}