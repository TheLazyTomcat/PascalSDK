(**
 * @file scssdk_input_eut2.h
 *
 * @brief ETS2 input specific constants.
 *)
unit scssdk_input_eut2;

{$INCLUDE '../scssdk_defs.inc'}

interface

uses
  scssdk;

(**
 * @name Value used in the scs_sdk_init_params_t::game_version
 *
 * Changes in the major version indicate incompatible changes.
 * Changes in the minor version indicate compatible changes (e.g. added more types)
 *
 * Changes:
 * 1.00 - initial version
 *)
//@{
const
  SCS_INPUT_EUT2_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0){0x00010000};
  SCS_INPUT_EUT2_GAME_VERSION_CURRENT = SCS_INPUT_EUT2_GAME_VERSION_1_00;
//@}

implementation

end.
