(**
 * @file scssdk_eut2.h
 *
 * @brief ETS 2 specific constants.
 *)
unit scssdk_eut2;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;

(**
 * @brief Value used in the scs_sdk_init_params_t::game_id to identify this game.
 *)
const
  SCS_GAME_ID_EUT2 = TelemetryString('eut2');

implementation

end.
