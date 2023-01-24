(**
 * @file scssdk_telemetry_job_common_channels.h
 *
 * @brief Job telemetry specific constants for channels.
 *)
unit scssdk_telemetry_job_common_channels;

{$INCLUDE '../scssdk_defs.inc'}

interface

uses
  scssdk;

(**
 * @brief The total damage of the cargo in range 0.0 to 1.0.
 *
 * Type: float
 *)
const
  SCS_TELEMETRY_JOB_CHANNEL_cargo_damage = TelemetryString('job.cargo.damage');

implementation

end.
