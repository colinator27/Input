# Functions (Players)

&nbsp;

The functions on this page relate to player properties - whether they're connected, what sort of gamepad they're using, how many players are playing and so on.

If you're looking for a way to control what [source](Input-Sources) a player is using, including turning hotswapping on and off, please read the [source functions](Functions-(Sources)) documentation. If you're looking for a way to change a player's [binding profile](Profiles) then the [profile functions](Functions-(Profiles)) page will be helpful for you.

&nbsp;

## …player_connected

`input_player_connected([playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** Boolean, whether any of the player's [sources](Input-Sources) are connected and available for use

|Name           |Datatype|Purpose                                             |
|---------------|--------|----------------------------------------------------|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used|

If the player's sole source is a gamepad and that gamepad is [incompatible with SDL2](Controller-Mapping?id=controller-blacklist) then this function will return `false`.

?> Players that are designated as ["ghosts"](Functions-(Players)?id=input_player_ghost_setstate-playerindex) will always be considered connected.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …players_connected_count

`input_players_connected_count()`

<!-- tabs:start -->

#### **Description**

**Returns:** Integer, the number of players with connected devices

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

?> Players that are designated as ["ghosts"](Functions-(Players)?id=input_player_ghost_setstate-playerindex) will always be considered connected.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …players_get_status

`input_players_get_status()`

<!-- tabs:start -->

#### **Description**

**Returns:** Struct, detailing the state of player connection and disconnection

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This function returns a struct that describes the state of each player's connectivity, following the formatting below. This data is useful for detecting a change in player state wherein the game may need to create a new instance for that player or show a disconnection warning.

!> Do not edit the struct that this function returns! You may encounter undefined behaviour if you do.

```
{
    any_changes: <boolean that indicates whether anything has changed at all>
    new_connections: [
        <array of player indexes that are newly connected this step>
    ],
    new_disconnections: [
        <array of player indexes that are newly disconnected this step>
    ],
    players: [
        <array of values from the INPUT_STATUS enum, one for each player up to INPUT_MAX_PLAYERS>
    ],
}
```

The `INPUT_STATUS` enum contains the following members:

|Name                 |Purpose                                         |
|---------------------|------------------------------------------------|
|`.NEWLY_DISCONNECTED`|Player has been disconnected this frame         |
|`.DISCONNECTED`      |Player is disconnected (for at least two frames)|
|`.NEWLY_CONNECTED`   |Player has been connected this frame            |
|`.CONNECTED`         |Player is connected (for at least two frames)   |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_get_gamepad

`input_player_get_gamepad([playerIndex], [binding])`

<!-- tabs:start -->

#### **Description**

**Returns:** Integer, a [gamepad](https://manual.yoyogames.com/#t=GameMaker_Language%2FGML_Reference%2FGame_Input%2FGamePad_Input%2FGamepad_Input.htm) index

|Name           |Datatype                     |Purpose                                                                                                                                                                                                    |
|---------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[playerIndex]`|integer                      |Player to target. If not specified, player 0 is used                                                                                                                                                       |
|`[binding]`    |[binding](Verbs-and-Bindings)|Binding to return the gamepad for. This is only valid in [multidevice mode](Input-Sources?id=input_source_modemultidevice). If no binding is provided then the player's first connected gamepad is returned|

This function will return `-1` if the player has no connected gamepad. If you provide a [binding](Verbs-and-Bindings) to check, and Input is running in [multidevice mode](Input-Sources?id=input_source_modemultidevice), then this function will return the gamepad index for the specific gamepad associated with the provided binding.

?> If the player has multiple gamepad [sources](Input-Sources) assigned to them, and no binding is provided, then this function will return the index of the first connected gamepad.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_get_gamepad_type

`input_player_get_gamepad_type([playerIndex], [binding])`

<!-- tabs:start -->

#### **Description**

**Returns:** String, a constant indicating the player's [gamepad type constant](Library-Constants#gamepad-types)

|Name           |Datatype                     |Purpose                                                                                                                                                                                                    |
|---------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[playerIndex]`|integer                      |Player to target. If not specified, player 0 is used                                                                                                                                                       |
|`[binding]`    |[binding](Verbs-and-Bindings)|Binding to return the gamepad for. This is only valid in [multidevice mode](Input-Sources?id=input_source_modemultidevice). If no binding is provided then the player's first connected gamepad is returned|

[XInput](https://wikipedia.org/wiki/DirectInput#XInput) controllers will typically return `INPUT_GAMEPAD_TYPE_XBOX_ONE` whereas any unrecognised gamepad will return `INPUT_GAMEPAD_TYPE_UNKNOWN`. Xbox Series X/S controllers will return `INPUT_GAMEPAD_TYPE_XBOX_ONE` owing to similarities across console generations, and that Xbox One gamepads are forwards compatible.

If the player has no connected gamepad then this function will return `INPUT_GAMEPAD_TYPE_UNKNOWN`. If you provide a [binding](Verbs-and-Bindings) to check, and Input is running in [multidevice mode](Input-Sources?id=input_source_modemultidevice), then this function will return the [gamepad type constant](Library-Constants#gamepad-types) for the specific gamepad associated with the provided binding.

?> If the player has multiple gamepad [sources](Input-Sources) assigned to them, and no binding is provided, then this function will return the type for the first connected gamepad.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_get_invalid_gamepad_bindings

`input_player_get_invalid_gamepad_bindings([playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** Array of structs, gamepad bindings that are invalid due to the gamepad lacking certain mapped inputs

|Name           |Datatype|Purpose                                             |
|---------------|--------|----------------------------------------------------|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used|

This functions checks to see whether the current bindings for the given player are valid. Any bindings that are found to be invalid are stored and returned as an array. If there are no invalid bindings, this function will return an empty array.

An invalid binding occurs when the player's gamepad lacks a button or axis that the current binding scheme requires. For example, single Switch Joy-Cons lack a dpad; if the player has a verb mapped to one of the dpad buttons then that verb is no longer accessible if the player uses a single Joy-Con to play.

Single Switch Joy-Cons are far from the only gamepad with fewer buttons than a "standard" Xbox / PlayStation controller. How you respond to devices that lack certain buttons is up to you. In the specific case of single Joy-Cons, Input offers [functionality to handle them automatically](Functions-(Default-Bindings)#input_default_joycon_buttonbutton-verb-alternate).

The array returned by this function contains structs. Each struct contains two member variables:

|Name       |Description                                                                                                                                                                        |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`verb`     |[Verb](https://www.jujuadams.com/Input/#/3.5/Verbs-and-Alternate-Bindings) that contains the invalid binding                                                                       |
|`alternate`|[Alternate index](https://www.jujuadams.com/Input/#/3.5/Verbs-and-Alternate-Bindings) for the invalid binding                                                                      |
|`gm`       |[Virtual button/axis constant](https://manual.yoyogames.com/#t=GameMaker_Language%2FGML_Reference%2FGame_Input%2FGamePad_Input%2FGamepad_Input.htm) that is missing from the player's gamepad|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_ghost_set

`input_player_ghost_set(state, [playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** N/A (`undefined`)

|Name           |Datatype|Purpose                                              |
|---------------|--------|-----------------------------------------------------|
|`state`        |boolean |Whether the player should be set to ghost mode or not|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used |

Ghost mode prevents any sources being assigned to this player, but the player is always considered connected. This is useful for a number of things in your game:
- Representing remote players in networked multiplayer
- AI-controlled players
- Replaying gameplay e.g. showing gameplay for the best track time in a racing game

!> When you set a player to ghost mode, all [sources](Input-Sources) assigned to the target player are cleared.

?> To manually pipe input to a ghost player, please use [`input_verb_set()`](Functions-(Other)?id=input_verb_setverb-value-playerindex).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_ghost_get

`input_player_ghost_get([playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** Boolean, whether the player is in ghost mode

|Name           |Datatype|Purpose                                              |
|---------------|--------|-----------------------------------------------------|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_swap

`input_player_swap(playerIndexA, playerIndexB)`

<!-- tabs:start -->

#### **Description**

**Returns:** N/A (`undefined`)

|Name          |Datatype|Purpose                |
|--------------|--------|-----------------------|
|`playerIndexA`|integer |First player to target |
|`playerIndexB`|integer |Second player to target|

This function will swap over the two players with the given indices. This includes any player input state, bindings, source etc.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_gamepad_type_override_set

`input_player_gamepad_type_override_set(gamepadType, [playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** N/A (`undefined`)

|Name           |Datatype|Purpose                                              |
|---------------|--------|-----------------------------------------------------|
|`gamepadType`  |string  |[Gamepad type](Library-Constants#gamepad-types)  to use for icon getters                 |
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used |

This function forces the icon getter functions (`input_verb_get_icon()` and `input_binding_get_icon()`) to use a specific [gamepad type](Library-Constants#gamepad-types)  when the player is using a gamepad. Use a gamepad type of `undefined` to not force a gamepad type.

!> `input_player_gamepad_type_override_set()` only changes what icons are displayed. It doesn't change the value returned from `input_player_get_gamepad_type()`.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## …player_gamepad_type_override_get

`input_player_gamepad_type_override_get([playerIndex])`

<!-- tabs:start -->

#### **Description**

**Returns:** String, what [gamepad type constant](Library-Constants#gamepad-types)  override has been set (or `undefined` if none has been set)

|Name           |Datatype|Purpose                                              |
|---------------|--------|-----------------------------------------------------|
|`[playerIndex]`|integer |Player to target. If not specified, player 0 is used |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->