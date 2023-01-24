(**
 * @file scssdk_telemetry_eut2.h
 *
 * @brief ETS 2 telemetry specific constants.
 *)
unit scssdk_telemetry_eut2;

{$INCLUDE '../scssdk_defs.inc'}

interface

uses
  scssdk;

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
 * 1.01 - added brake_air_pressure_emergency channel and air_pressure_emergency config
 * 1.02 - replaced cabin_orientation channel with cabin_offset channel
 * 1.03 - fixed reporting of invalid index value for wheels.count attribute
 * 1.04 - added lblinker_light and rblinker_light channels
 * 1.05 - fixed content of brand_id and brand attributes
 * 1.06 - fixed index value for selector_count attribute. It is now SCS_U32_NIL as the
 *        attribute is not indexed. For backward compatibility additional copy with
 *        index 0 is also present however it will be removed in the future.
 * 1.07 - fixed calculation of cabin_angular_acceleration channel.
 * 1.08 - a empty truck/trailer configuration event is generated when truck is removed
 *        (e.g. after completion of quick job)
 * 1.09 - added time and job related info
 * 1.10 - added information about liftable axes
 * 1.11 - u32 channels can provide u64 as documented, added displayed_gear channel, increased
 *        maximum number of supported wheel channels to 14
 * 1.12 - added information about transmission (differential_ratio, forward_ratio, reverse_ratio),
 *        navigation channels (navigation_distance, navigation_time, navigation_speed_limit)
 *        and adblue related data are now provided.
 * 1.13 - fixed values of id and cargo_accessory_id attributes in trailer config broken by
 *        ETS2 1.25 update. Note that the new values will be different from the ones returned
 *        by ETS2 1.24 and older.
 * 1.14 - added support for multiple trailers (doubles, triples), trailer ownership support,
 *        gameplay events support added
 * 1.15 - added planned_distance_km to active job info
 * 1.16 - added support for 'avoid_inspection', 'illegal_border_crossing' and 'hard_shoulder_violation' offence type in 'player.fined' gameplay event
 * 1.17 - added differential lock, lift axle and hazard warning channels
 * 1.18 - added multiplayer time offset and trailer body wear channel, fixed trailer chassis wear channel
 *)
//@{
const
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0) {0x00010000};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_01    = scs_u32_t((1 shl 16) or 1) {0x00010001};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_02    = scs_u32_t((1 shl 16) or 2) {0x00010002};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_03    = scs_u32_t((1 shl 16) or 3) {0x00010003};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_04    = scs_u32_t((1 shl 16) or 4) {0x00010004};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_05    = scs_u32_t((1 shl 16) or 5) {0x00010005};  // Patch 1.4
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_06    = scs_u32_t((1 shl 16) or 6) {0x00010006};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_07    = scs_u32_t((1 shl 16) or 7) {0x00010007};  // Patch 1.6
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_08    = scs_u32_t((1 shl 16) or 8) {0x00010008};  // Patch 1.9
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_09    = scs_u32_t((1 shl 16) or 9) {0x00010009};  // Patch 1.14 beta
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_10    = scs_u32_t((1 shl 16) or 10){0x0001000A};  // Patch 1.14
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_11    = scs_u32_t((1 shl 16) or 11){0x0001000B};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_12    = scs_u32_t((1 shl 16) or 12){0x0001000C};  // Patch 1.17
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_13    = scs_u32_t((1 shl 16) or 13){0x0001000D};  // Patch 1.27
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_14    = scs_u32_t((1 shl 16) or 14){0x0001000E};  // Patch 1.35
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_15    = scs_u32_t((1 shl 16) or 15){0x0001000F};  // Patch 1.36
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_16    = scs_u32_t((1 shl 16) or 16){0x00010010};  // Patch 1.36
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_17    = scs_u32_t((1 shl 16) or 17){0x00010011};  // Patch 1.41
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_18    = scs_u32_t((1 shl 16) or 18){0x00010012};  // Patch 1.45
  SCS_TELEMETRY_EUT2_GAME_VERSION_CURRENT = SCS_TELEMETRY_EUT2_GAME_VERSION_1_18;
//@}

// Game specific units.
//
// @li The game uses Euro as internal currency provided
//     by the telemetry unless documented otherwise.

// Channels defined in scssdk_telemetry_common_channels.h,
// scssdk_telemetry_job_common_channels.h,
// scssdk_telemetry_truck_common_channels.h and
// scssdk_telemetry_trailer_common_channels.h are supported
// with following exceptions and limitations as of v1.00:
//
// @li Rolling rotation of trailer wheels is determined from linear
//     movement.
// @li The pressures, temperatures and voltages are not simulated.
//     They are very loosely approximated.

// Configurations defined in scssdk_telemetry_common_configs.h are
// supported with following exceptions and limitations as of v1.00:
//
// @li The localized strings are not updated when different in-game
//     language is selected.

implementation

end.
