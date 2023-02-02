{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  PascalSDK

    A translation of SCS Software's SDK (SCS SDK) for data exchange and
    communication between a running game and a loaded dynamic library into
    the Pascal programming language.

  Version 1.0 (2023-02-02)

  Last changed 2023-02-02

  �2023 Franti�ek Milt

  Contacts:
    Franti�ek Milt: frantisek.milt@gmail.com

  Support:
    If you find this code useful, please consider supporting its author(s) by
    making a small donation using the following link(s):

      https://www.paypal.me/FMilt

  Changelog:
    For detailed changelog and history please refer to this git repository:

      github.com/TheLazyTomcat/PascalSDK

  Dependencies:
    AuxTypes - github.com/TheLazyTomcat/Lib.AuxTypes
    StrRect  - github.com/TheLazyTomcat/Lib.StrRect

===============================================================================}
(*<unit>*)
(**
 * @file scssdk_telemetry_common_channels.h
 *
 * @brief Telemetry specific channels which might be used by more than one game.
 *)
unit scssdk_telemetry_common_channels;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * @brief Scale applied to distance and time to compensate
 * for the scale of the map (e.g. 1s of real time corresponds to local_scale
 * seconds of simulated game time).
 *
 * Games which use real 1:1 maps will not provide this
 * channel.
 *
 * Type: float
 *)
const
  SCS_TELEMETRY_CHANNEL_local_scale = SDKString('local.scale');

(**
 * @brief Absolute in-game time.
 *
 * Represented in number of in-game minutes since beginning (i.e. 00:00)
 * of the first in-game day.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CHANNEL_game_time = SDKString('game.time');

(**
 * @brief Offset from the game_time simulated in the local economy to the
 * game time of the Convoy multiplayer server.
 *
 * The value of this channel can change frequently during the Convoy
 * session. For example when the user enters the desktop, the local
 * economy time stops however the multiplayer time continues to run
 * so the value will start to change.
 *
 * Represented in in-game minutes. Set to 0 when multiplayer is not active.
 *
 * Type: s32
 *)
  SCS_TELEMETRY_CHANNEL_multiplayer_time_offset = SDKString('multiplayer.time.offset');

(**
 * @brief Time until next rest stop.
 *
 * When the fatique simulation is disabled, the behavior of this channel
 * is implementation dependent. The game might provide the value which would
 * apply if it was enabled or provide no value at all.
 *
 * Represented in in-game minutes.
 *
 * Type: s32
 *)
  SCS_TELEMETRY_CHANNEL_next_rest_stop = SDKString('rest.stop');
  
(*</interface>*)

implementation

(*</unit>*)
end.
