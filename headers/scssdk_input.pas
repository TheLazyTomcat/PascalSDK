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
 * @file scssdk_input.h
 *
 * @brief Input SDK.
 *)
unit scssdk_input;

{$INCLUDE scssdk_defs.inc}

interface

uses
  scssdk,
  scssdk_input_device;

(*<interface>*)

(**
 * @name Versions of the input SDK
 *
 * Changes in the major version indicate incompatible changes in the API.
 * Changes in the minor version indicate additions.
 *)
//@{
const
  SCS_INPUT_VERSION_1_00    = scs_u32_t((1 shl 16) or 0){0x00010000};
  SCS_INPUT_VERSION_CURRENT = SCS_INPUT_VERSION_1_00;
//@}

// Structures used to pass additional data to the initialization function.

(**
 * @brief Common ancestor to all structures providing parameters to the input
 * initialization.
 *)
{
  No working analog in pascal for the original code.

type
  scs_input_init_params_t = record
    procedure method_indicating_this_is_not_a_c_struct;
  end;
  p_scs_input_init_params_t = ^scs_input_init_params_t;
}

(**
 * @brief Initialization parameters for the 1.00 version of the input API.
 *)
type
  scs_input_init_params_v100_t = record
    (**
     * @brief Common initialization parameters.
     *)
    common:           scs_sdk_init_params_v100_t;

    (**
     * @name Function used to register input device.
     *)
    register_device:  scs_input_register_device_t;
  end;
  p_scs_input_init_params_v100_t = ^scs_input_init_params_v100_t;

  scs_input_init_params_t = scs_input_init_params_v100_t;
  p_scs_input_init_params_t = ^scs_input_init_params_t;

// Functions which should be exported by the dynamic library serving as
// recipient of the input.

(**
 * @brief Initializes input support.
 *
 * This function must be provided by the library if it wants to support input API.
 *
 * The engine will call this function with API versions it supports starting from the latest
 * until the function returns SCS_RESULT_ok or error other than SCS_RESULT_unsupported or it
 * runs out of supported versions.
 *
 * @param version Version of the API to initialize.
 * @param params Structure with additional initialization data specific to the specified API version.
 * @return SCS_RESULT_ok if version is supported and library was initialized. Error code otherwise.
 *)
  scs_input_init = Function(version: scs_u32_t; params: p_scs_input_init_params_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Shuts down the input support.
 *
 * The engine will call this function if available and if the scs_input_init indicated
 * success.
 *)
  scs_input_shutdown = procedure; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};
  
(*</interface>*)

implementation

{$IFDEF AssertTypeSize}
initialization
(*<initialization>*)
  Assert(scs_check_size(SizeOf(scs_input_init_params_v100_t),20,40));
(*</initialization>*)
{$ENDIF}

(*</unit>*)
end.
