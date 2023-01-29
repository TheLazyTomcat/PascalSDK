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
  SCS_TELEMETRY_TRAILER_CHANNEL_connected = TelemetryString('trailer.connected');

(**
 * @brief How much is the cargo damaged that is loaded to this trailer in <0.0, 1.0> range.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRAILER_CHANNEL_cargo_damage = TelemetryString('trailer.cargo.damage');

(**
 * @name Channels similar to the truck ones
 *
 * See scssdk_telemetry_truck_common_channels.h for description of
 * corresponding truck channels
 *)
//@{
  SCS_TELEMETRY_TRAILER_CHANNEL_world_placement             = TelemetryString('trailer.world.placement');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_velocity       = TelemetryString('trailer.velocity.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_velocity      = TelemetryString('trailer.velocity.angular');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_acceleration   = TelemetryString('trailer.acceleration.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_acceleration  = TelemetryString('trailer.acceleration.angular');

// Damage.

  SCS_TELEMETRY_TRAILER_CHANNEL_wear_body    = TelemetryString('trailer.wear.body');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_chassis = TelemetryString('trailer.wear.chassis');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_wheels  = TelemetryString('trailer.wear.wheels');

// Wheels.

  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_susp_deflection = TelemetryString('trailer.wheel.suspension.deflection');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_on_ground       = TelemetryString('trailer.wheel.on_ground');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_substance       = TelemetryString('trailer.wheel.substance');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_velocity        = TelemetryString('trailer.wheel.angular_velocity');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_steering        = TelemetryString('trailer.wheel.steering');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_rotation        = TelemetryString('trailer.wheel.rotation');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift            = TelemetryString('trailer.wheel.lift');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift_offset     = TelemetryString('trailer.wheel.lift.offset');
//@}

(*</interface>*)

implementation

(*</unit>*)
end.
