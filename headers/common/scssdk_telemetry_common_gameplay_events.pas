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
 * @file scssdk_telemetry_common_gameplay_events.h
 *
 * @brief Telemetry specific gameplay events which might be used by more than one game.
 *)
unit scssdk_telemetry_common_gameplay_events;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * @brief Event called when job is cancelled.
 *
 * Attributes:
 * @li cancel_penalty
 *)
const 
  SCS_TELEMETRY_GAMEPLAY_EVENT_job_cancelled = SDKString('job.cancelled');

(**
 * @brief Event called when job is delivered.
 *
 * Attributes:
 * @li revenue
 * @li earned_xp
 * @li cargo_damage
 * @li distance_km
 * @li delivery_time
 * @li autopark_used
 * @li autoload_used
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_job_delivered = SDKString('job.delivered');

(**
 * @brief Event called when player gets fined.
 *
 * Attributes:
 * @li fine_offence
 * @li fine_amount
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_player_fined = SDKString('player.fined');

(**
 * @brief Event called when player pays for a tollgate.
 *
 * Attributes:
 * @li pay_amount
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_player_tollgate_paid = SDKString('player.tollgate.paid');

(**
 * @brief Event called when player uses a ferry.
 *
 * Attributes:
 * @li pay_amount
 * @li source_name
 * @li target_name
 * @li source_id
 * @li target_id
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_player_use_ferry = SDKString('player.use.ferry');

(**
 * @brief Event called when player uses a train.
 *
 * Attributes:
 * @li pay_amount
 * @li source_name
 * @li target_name
 * @li source_id
 * @li target_id
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_player_use_train = SDKString('player.use.train');

// Attributes

(**
 * @brief The penalty for cancelling the job in native game currency. (Can be 0)
 *
 * Type: s64
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_cancel_penalty = SDKString('cancel.penalty');

(**
 * @brief The job revenue in native game currency.
 *
 * Type: s64
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_revenue = SDKString('revenue');

(**
 * @brief How much XP player received for the job.
 *
 * Type: s32
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_earned_xp = SDKString('earned.xp');

(**
 * @brief Total cargo damage. (Range <0.0, 1.0>)
 *
 * Type: float
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_cargo_damage = SDKString('cargo.damage');

(**
 * @brief The real distance in km on the job.
 *
 * Type: float
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_distance_km = SDKString('distance.km');

(**
 * @brief Total time spend on the job in game minutes.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_delivery_time = SDKString('delivery.time');

(**
 * @brief Was auto parking used on this job?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_auto_park_used = SDKString('auto.park.used');

(**
 * @brief Was auto loading used on this job? (always @c true for non cargo market jobs)
 *
 * Type: bool
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_auto_load_used = SDKString('auto.load.used');

(**
 * @brief Fine offence type.
 *
 * Possible values:
 * @li crash
 * @li avoid_sleeping
 * @li wrong_way
 * @li speeding_camera
 * @li no_lights
 * @li red_signal
 * @li speeding
 * @li avoid_weighing
 * @li illegal_trailer
 * @li avoid_inspection
 * @li illegal_border_crossing
 * @li hard_shoulder_violation
 * @li damaged_vehicle_usage
 * @li generic
 *
 * Type: string
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_fine_offence = SDKString('fine.offence');

(**
 * @brief Fine offence amount in native game currency.
 *
 * Type: s64
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_fine_amount = SDKString('fine.amount');

(**
 * @brief How much player was charged for this action (in native game currency)
 *
 * Type: s64
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_pay_amount = SDKString('pay.amount');

(**
 * @brief The name of the transportation source.
 *
 * Type: string
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_source_name = SDKString('source.name');

(**
 * @brief The name of the transportation target.
 *
 * Type: string
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_target_name = SDKString('target.name');

(**
 * @brief The id of the transportation source.
 *
 * Type: string
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_source_id = SDKString('source.id');

(**
 * @brief The id of the transportation target.
 *
 * Type: string
 *)
  SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_target_id = SDKString('target.id');
  
(*</interface>*)

implementation

(*</unit>*)
end.
