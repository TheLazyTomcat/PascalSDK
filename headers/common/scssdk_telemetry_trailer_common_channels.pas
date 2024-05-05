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
 * @file scssdk_telemetry_trailer_common_channels.h
 *
 * @brief Trailer telemetry specific constants for channels.
 *
 * See scssdk_telemetry_truck_common_channels.h for more info.
 *)
unit scssdk_telemetry_trailer_common_channels;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * Telemetry SDK supports multiple trailers.
 *
 * To get information about more trailers replace "trailer." with "trailer.[index].".
 * Connected state for trailers would be:
 *
 * First trailer: "trailer.0.connected"
 * Second trailer: "trailer.1.connected"
 * ...
 * Six-th trailer: "trailer.5.connected"
 * etc
 *
 * Maximum number of trailers that can be reported by telemetry SDK
 * is defined by @c SCS_TELEMETRY_trailers_count.
 *)

(**
 * @brief Is the trailer connected to the truck?
 *
 * Type: bool
 *)
const
  SCS_TELEMETRY_TRAILER_CHANNEL_connected = SDKString('trailer.connected');

(**
 * @brief How much is the cargo damaged that is loaded to this trailer in <0.0, 1.0> range.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRAILER_CHANNEL_cargo_damage = SDKString('trailer.cargo.damage');

(**
 * @name Channels similar to the truck ones
 *
 * See scssdk_telemetry_truck_common_channels.h for description of
 * corresponding truck channels
 *)
//@{
  SCS_TELEMETRY_TRAILER_CHANNEL_world_placement             = SDKString('trailer.world.placement');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_velocity       = SDKString('trailer.velocity.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_velocity      = SDKString('trailer.velocity.angular');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_acceleration   = SDKString('trailer.acceleration.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_acceleration  = SDKString('trailer.acceleration.angular');

// Damage.

  SCS_TELEMETRY_TRAILER_CHANNEL_wear_body    = SDKString('trailer.wear.body');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_chassis = SDKString('trailer.wear.chassis');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_wheels  = SDKString('trailer.wear.wheels');

// Wheels.

  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_susp_deflection = SDKString('trailer.wheel.suspension.deflection');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_on_ground       = SDKString('trailer.wheel.on_ground');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_substance       = SDKString('trailer.wheel.substance');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_velocity        = SDKString('trailer.wheel.angular_velocity');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_steering        = SDKString('trailer.wheel.steering');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_rotation        = SDKString('trailer.wheel.rotation');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift            = SDKString('trailer.wheel.lift');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift_offset     = SDKString('trailer.wheel.lift.offset');
//@}

(*</interface>*)

implementation

(*</unit>*)
end.
