/// @param state

function input_accessibility_global_toggle_set(_state)
{
    __input_initialize();
    
    global.__input_toggle_momentary_state = _state;
}