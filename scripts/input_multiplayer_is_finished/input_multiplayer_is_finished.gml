/// @desc    Returns whether enough players have connected for valid gameplay

function input_multiplayer_is_finished()
{
    __INPUT_GLOBAL_STATIC_LOCAL
    
    var _connected = input_player_connected_count();
    return ((_connected >= _global.__multiplayer_min) && (_connected <= _global.__multiplayer_max));
}