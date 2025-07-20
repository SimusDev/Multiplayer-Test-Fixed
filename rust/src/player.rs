use godot::classes::{CharacterBody2D, ICharacterBody2D, Input, MultiplayerApi};
use godot::classes::{ISprite2D, Sprite2D, InputEvent};
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
#[class(base=Sprite2D)]
pub struct Test {
    base: Base<Sprite2D>,

    #[export]
    forward_key:GString,
    #[export]
    backward_key:GString,
}

#[godot_api]
impl ISprite2D for Test {
    fn init(base: Base<Sprite2D>) -> Self {
        Self {
            base,
            forward_key: GString::from("w"),
            backward_key: GString::from("s"),
        }
    }
    
    fn ready(&mut self,) {
        godot::global::godot_print!("self is: {}", self.base);
        godot::global::godot_print!("fwd_key: {}", self.forward_key);
        godot::global::godot_print!("backward_key: {}", self.backward_key);
    }

    fn input(&mut self, event: Gd<InputEvent>,) {
        let event_key: GString = event.as_text();
        if &event_key.to_lower() == &self.forward_key {
            godot::global::godot_print!("forward");
        }
        if &event_key.to_lower() == &self.backward_key {
            godot::global::godot_print!("backward");
        }
    }
}

    
