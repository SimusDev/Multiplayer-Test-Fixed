use godot::classes::{ISprite2D, Sprite2D, InputEvent};
use godot::prelude::*;

#[derive(GodotClass)]
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

    