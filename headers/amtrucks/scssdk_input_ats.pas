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

  Version 1.0 (2023-02-01)

  Last changed 2023-02-01

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
(*<unit>*)
(**
 * @file scssdk_input_ats.h
 *
 * @brief ATS input specific constants.
 *)
unit scssdk_input_ats;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

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
  SCS_INPUT_ATS_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0) {0x00010000};
  SCS_INPUT_ATS_GAME_VERSION_CURRENT = SCS_INPUT_ATS_GAME_VERSION_1_00;
//@}

(*</interface>*)

implementation

(*</unit>*)
end.
