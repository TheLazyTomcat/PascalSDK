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

  Last changed 2023-12-29

  ©2023 František Milt

  Contacts:
    František Milt: frantisek.milt@gmail.com

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
{!tun_end!}
(*<unit>*)
(**
 * @file scssdk_telemetry_ats.h
 *
 * @brief ATS telemetry specific constants.
 *)
unit scssdk_telemetry_ats;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * @name Value used in the scs_sdk_init_params_t::game_version
 *
 * Changes in the major version indicate incompatible changes (e.g. changed interpretation
 * of the channel value). Change of major version is highly discouraged, creation of
 * alternative channel is preferred solution if necessary.
 * Changes in the minor version indicate compatible changes (e.g. added channel, more supported
 * value types). Removal of channel is also compatible change however it is recommended
 * to keep the channel with some default value.
 *
 * Changes:
 * 1.00 - initial version - corresponds to 1.12 in ETS2
 * 1.01 - added support for multiple trailers (doubles, triples), trailer ownership support,
 *        gameplay events support added
 * 1.02 - added planned_distance_km to active job info
 * 1.03 - added support for 'avoid_inspection', 'illegal_border_crossing' and 'hard_shoulder_violation' offence type in 'player.fined' gameplay event
 * 1.04 - added differential lock, lift axle and hazard warning channels
 * 1.05 - added multiplayer time offset and trailer body wear channel, fixed trailer chassis wear channel
 *)
//@{
const
  SCS_TELEMETRY_ATS_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0) {0x00010000};
  SCS_TELEMETRY_ATS_GAME_VERSION_1_01    = scs_u32_t((1 shl 16) or 1) {0x00010001};
  SCS_TELEMETRY_ATS_GAME_VERSION_1_02    = scs_u32_t((1 shl 16) or 2) {0x00010002}; // Patch 1.36
  SCS_TELEMETRY_ATS_GAME_VERSION_1_03    = scs_u32_t((1 shl 16) or 3) {0x00010003}; // Patch 1.36
  SCS_TELEMETRY_ATS_GAME_VERSION_1_04    = scs_u32_t((1 shl 16) or 4) {0x00010004}; // Patch 1.41
  SCS_TELEMETRY_ATS_GAME_VERSION_1_05    = scs_u32_t((1 shl 16) or 5) {0x00010005}; // Patch 1.45
  SCS_TELEMETRY_ATS_GAME_VERSION_CURRENT = SCS_TELEMETRY_ATS_GAME_VERSION_1_05;
//@}

// Game specific units.
//
// @li The game uses US Dolars as internal currency provided
//     by the telemetry unless documented otherwise.

// Channels defined in scssdk_telemetry_common_channels.h,
// scssdk_telemetry_job_common_channels.h,
// scssdk_telemetry_truck_common_channels.h and
// scssdk_telemetry_trailer_common_channels.h are supported
// with following exceptions and limitations as of v1.00:
//
// @li Adblue related channels are not supported.
// @li The fuel_average_consumption is currently mostly static and depends
//     on presence of the trailer and skills of the driver instead
//     of the workload of the engine.
// @li Rolling rotation of trailer wheels is determined from linear
//     movement.
// @li The pressures, temperatures and voltages are not simulated.
//     They are very loosely approximated.

// Configurations defined in scssdk_telemetry_common_configs.h are
// supported with following exceptions and limitations as of v1.00:
//
// @li The localized strings are not updated when different in-game
//     language is selected.

(*</interface>*)

implementation

(*</unit>*)
end.
