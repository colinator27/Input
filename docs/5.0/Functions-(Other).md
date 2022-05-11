# Functions (Other)

&nbsp;

## `input_tick()`

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

!> If you're using Input 5 on versions of GameMaker **before** 2022.5 (May 2022) then you'll need to call `input_tick()` in the Begin Step event of a persistent instance. This function handles all things Input behind the scenes, it is important to call `input_tick()` once (and only once) each step of your game. A good way to do this is by making `obj_input_manager` [persistent](https://manual.yoyogames.com/#t=The_Asset_Editors%2FObjects.htm), and placing one instance in your first room.

&nbsp;

## `input_axis_threshold_set(axis, min, max, [playerIndex])`

*Returns:* A struct with two member variables, `mini` and `maxi`, containing the minimum and maximum thresholds

|Name           |Datatype|Purpose                                             |
|---------------|--------|----------------------------------------------------|
|`axis`         |real    |[Gamepad axis](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/controls/gamepad%20input/index.html) to target|
|`min`          |real    |Minimum threshold value                             |
|`max`          |real    |Maximum threshold value                             |
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used|

&nbsp;

## `input_axis_threshold_get(axis, [playerIndex])`

*Returns:* A struct with two member variables, `mini` and `maxi`, containing the minimum and maximum thresholds

|Name           |Datatype|Purpose                                             |
|---------------|--------|----------------------------------------------------|
|`axis`         |real    |[Gamepad axis](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/controls/gamepad%20input/index.html) to target|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used|

If the axis does not have a threshold definition (as set by `input_axis_threshold_set()`) when this function is called then a new definition is created using `INPUT_DEFAULT_MIN_THRESHOLD` and `INPUT_DEFAULT_MAX_THRESHOLD`.

&nbsp;

## `input_clear_momentary(state)`

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose       |
|-------|--------|--------------|
|`state`|boolean |Whether to clear all momentary input|

Clears momentary (pressed/released) input and connection checkers. This covers verbs as well as keyboard/mouse/gamepad direct checkers. Useful for [fixed timestep patterns](https://gafferongames.com/post/fix_your_timestep/) where momentary checks should only be handled for one cycle (for example [iota](https://github.com/JujuAdams/iota)).

&nbsp;

## `input_guess_keyboard_layout()`

*Returns:* String indicating keyboard layout hint, `QWERTY` `AZERTY` or `QWERTZ`

|Name           |Datatype                                                             |Purpose                                                                         |
|---------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------|
|None         | |

Provides a hint for default Latin keyboard layout based on available information. Utility for building safe default bindings based on [keyboard layout differences](https://www.typingpal.com/en/news/what-is-the-difference-between-QWERTY-QWERTZ-and-AZERTY-keyboards). Note that while system software determines the active keyboard layout and we can not detect this at runtime, this function provides a suggestion as to the system-default using OS locale info ([ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) and [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1)).

_Example usage_
```
if (input_guess_keyboard_layout() == "AZERTY")
{
    input_default_key(ord("E"), "up");
    input_default_key(ord("S"), "left");
    input_default_key(ord("D"), "down");
    input_default_key(ord("F"), "right");
}
else
{
    input_default_key(ord("W"), "up");
    input_default_key(ord("A"), "left");
    input_default_key(ord("S"), "down");
    input_default_key(ord("D"), "right");
}
```

&nbsp;

## `input_platform_text_source()`

*Returns:* String indicating platform text source, `async` `virtual` or `keyboard`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Provides a suggestion for text entry handling based on platform target.

&nbsp;

## `input_ignore_key_add(key)`

*Returns:* N/A (`undefined`)

|Name |Datatype|Purpose                                                                                                                 |
|-----|--------|------------------------------------------------------------------------------------------------------------------------|
|`key`|integer |[Key](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/controls/keyboard%20input/index.html) to add|

Adds a keyboard key to be ignored by Input. This will affect binding detection, but any existing bindings set up to scan for this key will still work to prevent players from getting themselves into a position where the game doesn't work (!).

**Please note** that the list of ignored keys may already be populated depending on what value is set for `INPUT_IGNORE_RESERVED_KEYS_LEVEL`. Please read the [`Configuration`](Configuration) page for more information.

&nbsp;

## `input_ignore_key_remove(key)`

*Returns:* N/A (`undefined`)

|Name |Datatype|Purpose                                                                                                                    |
|-----|--------|---------------------------------------------------------------------------------------------------------------------------|
|`key`|integer |[Key](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/controls/keyboard%20input/index.html) to remove|

Removes a keyboard key from the ignore list.