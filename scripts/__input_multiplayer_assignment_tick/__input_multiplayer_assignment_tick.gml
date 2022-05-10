function __input_multiplayer_assignment_tick()
{
    if (INPUT_MULTIPLAYER_LEAVE_VERB == undefined)
    {
        __input_error("INPUT_MULTIPLAYER_LEAVE_VERB has not been defined");
    }
    
    if (INPUT_MULTIPLAYER_ABORT_CALLBACK == undefined)
    {
        __input_error("INPUT_MULTIPLAYER_ABORT_CALLBACK has not been defined");
    }
    
    var _abort = false;
    
    if (global.__input_multiplayer_drop_down)
    {
        //Drop players down into empty spaces
        do
        {
            var _fail = false;
            var _p = INPUT_MAX_PLAYERS-1;
            repeat(INPUT_MAX_PLAYERS-1)
            {
                if (input_player_connected(_p) && !input_player_connected(_p-1))
                {
                    __input_trace("Assignment: Moving player ", _p, " (connected) to ", _p-1, " (disconnected)");
                    
                    _fail = true;
                    
                    var _temp = global.__input_players[_p-1];
                    global.__input_players[_p-1] = global.__input_players[_p];
                    global.__input_players[_p] = _temp;
                }
                
                --_p;
            }
        }
        until (!_fail);
    }
    
    //Disconnect all extraneous players
    var _p = global.__input_multiplayer_max;
    repeat(INPUT_MAX_PLAYERS - global.__input_multiplayer_max)
    {
        input_player_clear_sources(_p);
        ++_p;
    }
    
    //Scan for input for the lowest index slot
    var _p = 0;
    repeat(global.__input_multiplayer_max)
    {
        if (!input_player_connected(_p))
        {
            var _new_source = input_source_detect_new();
            if (_new_source != undefined)
            {
                with(global.__input_players[_p])
                {
                    __source_add(_new_source);
                    tick();
                }
                
                if (input_check_pressed(INPUT_MULTIPLAYER_LEAVE_VERB) && (input_players_connected() < global.__input_multiplayer_min) && (global.__input_multiplayer_min > 1))
                {
                    __input_trace("Assignment: Player ", _p, " aborted source assignment");
                    _abort = true;
                }
                else
                {
                    __input_trace("Assignment: Player ", _p, " joined");
                }
                
                //Make sure we don't leak input
                input_consume(all, _p);
            }
        }
        
        ++_p;
    }
    
    //Allow players to leave the game
    var _p = 0;
    repeat(global.__input_multiplayer_max)
    {
        if (input_check_pressed(INPUT_MULTIPLAYER_LEAVE_VERB, _p))
        {
            __input_trace("Assignment: Player ", _p, " left");
            input_player_clear_sources(_p);
        }
        
        ++_p;
    }
    
    if (_abort)
    {
        if (is_method(INPUT_MULTIPLAYER_ABORT_CALLBACK))
        {
            INPUT_MULTIPLAYER_ABORT_CALLBACK();
        }
        else if (is_numeric(INPUT_MULTIPLAYER_ABORT_CALLBACK) && script_exists(INPUT_MULTIPLAYER_ABORT_CALLBACK))
        {
            script_execute(INPUT_MULTIPLAYER_ABORT_CALLBACK);
        }
        else
        {
            __input_error("INPUT_MULTIPLAYER_ABORT_CALLBACK set to an illegal value (typeof=", typeof(INPUT_MULTIPLAYER_ABORT_CALLBACK), ")");
        }
    }
    
    return _abort;
}
