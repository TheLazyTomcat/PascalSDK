(*<unit>*)
(**
 * @file scssdk_ats.h
 *
 * @brief ATS specific constants.
 *)
unit scssdk_ats;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * @brief Value used in the scs_sdk_init_params_t::game_id to identify this game.
 *)
const
  SCS_GAME_ID_ATS = SDKString('ats');
  
(*</interface>*)

implementation

(*</unit>*)
end.
