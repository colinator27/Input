#macro INPUT_DEFAULT_PROFILES __input_initialize(); for(var _i = 0; _i < 2; _i++) if (_i == 1) __input_finalize_defaults() else if (is_struct(global.__input_default_profile_dict)) break else global.__input_default_profile_dict

function __input_finalize_defaults()
{
    if (!is_struct(global.__input_default_profile_dict))
    {
        __input_error("INPUT_DEFAULT_PROFILES must contain a struct (was ", typeof(global.__input_default_profile_dict), ")\nDocumentation on INPUT_DEFAULT_PROFILES can be found offline in __input_config_default_profiles()\nOnline documentation can be found at https://jujuadams.github.io/Input");
    }
    
    if (variable_struct_names_count(global.__input_default_profile_dict) <= 0)
    {
       __input_error("INPUT_DEFAULT_PROFILES must contain at least one profile");
    }
    
    global.__input_profile_array = variable_struct_get_names(global.__input_default_profile_dict);
    global.__input_profile_dict  = {}; //We fill this in later..
    
    var _f = 0;
    repeat(array_length(global.__input_profile_array))
    {
        var _profile_name   = global.__input_profile_array[_f];
        var _profile_struct = global.__input_default_profile_dict[$ _profile_name];
        
        if (!is_struct(_profile_struct))
        {
            __input_error("Profile \"", _profile_name, "\" definition must be a struct (was ", typeof(_profile_struct), ")");
        }
        
        //Copy the default profile reference across to the volatile dictionary
        global.__input_profile_dict[$ _profile_name] = _profile_struct;
        
        global.__input_default_player.__profile_ensure(_profile_name);
        
        var _profile_verb_names = variable_struct_get_names(_profile_struct);
        var _v = 0;
        repeat(array_length(_profile_verb_names))
        {
            var _verb_name = _profile_verb_names[_v];
            
            if (!variable_struct_exists(global.__input_basic_verb_dict, _verb_name))
            {
                array_push(global.__input_basic_verb_array, _verb_name);
                global.__input_basic_verb_dict[$ _verb_name] = true;
                
                array_push(global.__input_all_verb_array, _verb_name);
                global.__input_all_verb_dict[$ _verb_name] = true;
            }
            
            var _verb_data = _profile_struct[$ _verb_name];
            if (!is_array(_verb_data)) _verb_data = [_verb_data];
            
            if (array_length(_verb_data) > INPUT_MAX_ALTERNATE_BINDINGS)
            {
                __input_error("Profile \"", _profile_name, "\" definition must be a struct (was ", typeof(_profile_struct), ")");
            }
            
            global.__input_default_player.__ensure_verb(_profile_name, _verb_name);
            
            var _a = 0;
            repeat(array_length(_verb_data))
            {
                var _binding = _verb_data[_a];
                
                if (_binding == undefined)
                {
                    _binding = input_binding_empty();
                }
                else if (!input_value_is_binding(_binding))
                {
                    __input_error("Binding for profile \"", _profile_name, "\", verb \"", _verb_name, "\", alternate ", _a, " is not a binding\nPlease use one of the input_binding_*() functions to create bindings");
                }
                else
                {
                    switch(_binding.__get_source())
                    {
                        case INPUT_SOURCE.KEYBOARD:
                            global.__input_any_keyboard_binding_defined = true;
                            if (INPUT_KEYBOARD_AND_MOUSE_ALWAYS_PAIRED) global.__input_any_mouse_binding_defined = true;
                        break;
                        
                        case INPUT_SOURCE.MOUSE:
                            global.__input_any_mouse_binding_defined = true;
                            if (INPUT_KEYBOARD_AND_MOUSE_ALWAYS_PAIRED) global.__input_any_keyboard_binding_defined = true;
                        break;
                        
                        case INPUT_SOURCE.GAMEPAD:
                            global.__input_any_gamepad_binding_defined = true;
                        break;
                    }
                }
                
                global.__input_default_player.__binding_set(_profile_name, _verb_name, _a, _binding);
                
                ++_a;
            }
            
            ++_v;
        }
        
        ++_f;
    }
    
    if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_KEYBOARD)) __input_trace("Warning! Default profile for keyboard \"", INPUT_AUTO_PROFILE_FOR_KEYBOARD, "\" has not been defined");
    if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_MOUSE   )) __input_trace("Warning! Default profile for mouse \"",    INPUT_AUTO_PROFILE_FOR_MOUSE,    "\" has not been defined");
    if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_GAMEPAD )) __input_trace("Warning! Default profile for gamepad \"",  INPUT_AUTO_PROFILE_FOR_GAMEPAD,  "\" has not been defined");
    if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_MIXED   )) __input_trace("Warning! Default profile for mixed \"",    INPUT_AUTO_PROFILE_FOR_MIXED,    "\" has not been defined");
    
    //Fix any missing verb definitions for default profiles
    var _f = 0;
    repeat(array_length(global.__input_profile_array))
    {
        var _profile_name   = global.__input_profile_array[_f];
        var _profile_struct = global.__input_default_profile_dict[$ _profile_name];
        
        var _v = 0;
        repeat(array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            
            if (!variable_struct_exists(_profile_struct, _verb_name))
            {
                if (INPUT_ALLOW_ASSYMMETRIC_DEFAULT_PROFILES)
                {
                    __input_trace("Warning! Default profile \"", _profile_name, "\" does not include a definition for basic verb \"", _verb_name, "\"");
                }
                else
                {
                    __input_error("Default profile \"", _profile_name, "\" does not include a definition for basic verb \"", _verb_name, "\"\n(To ignore this error set INPUT_ALLOW_ASSYMMETRIC_DEFAULT_PROFILES to <false>)");
                }
                
                global.__input_default_player.__ensure_verb(_profile_name, _verb_name);
            }
            
            ++_v;
        }
        
        ++_f;
    }
    
    //Make sure every player has a copy of the default profiles
    input_binding_system_reset();
}