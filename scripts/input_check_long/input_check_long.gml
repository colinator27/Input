/// @param verb/array
/// @param [playerIndex]
/// @param [bufferDuration]

function input_check_long(_verb, _player_index = 0, _buffer_duration = 0)
{
    __INPUT_VERIFY_PLAYER_INDEX
    
    if (is_array(_verb))
    {
        var _i = 0;
        repeat(array_length(_verb))
        {
            if (input_check_long(_verb[_i], _player_index, _buffer_duration)) return true;
            ++_i;
        }
        
        return false;
    }
    
    __INPUT_GET_VERB_STRUCT
    
    if (_verb_struct.__inactive) return false;
    
    if (_buffer_duration <= 0)
    {
        return _verb_struct.long_held;
    }
    else
    {
        return ((_verb_struct.long_held_time >= 0) && ((__input_get_time() - _verb_struct.long_held_time) <= _buffer_duration));
    }
}