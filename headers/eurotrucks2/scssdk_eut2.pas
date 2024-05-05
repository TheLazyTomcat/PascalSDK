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
 * @file scssdk_eut2.h
 *
 * @brief ETS 2 specific constants.
 *)
unit scssdk_eut2;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

(**
 * @brief Value used in the scs_sdk_init_params_t::game_id to identify this game.
 *)
const
  SCS_GAME_ID_EUT2 = SDKString('eut2');
  
(*</interface>*)

implementation

(*</unit>*)
end.
