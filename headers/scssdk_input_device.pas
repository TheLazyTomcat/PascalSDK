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
 * @file scssdk_input_device.h
 *
 * @brief Input SDK - devices.
 *)
unit scssdk_input_device;

{$INCLUDE scssdk_defs.inc}

interface

uses
  scssdk,
  scssdk_value,
  scssdk_input_event;

(*<interface>*)

(**
 * @name Types of input devices.
 *)
//@{

type
  scs_input_device_type_t = scs_u32_t;
  p_scs_input_device_type_t = ^scs_input_device_type_t;

const
  SCS_INPUT_DEVICE_TYPE_INVALID = scs_input_device_type_t(0);

(**
 * @brief Generic device bindable in the game UI.
 *)
  SCS_INPUT_DEVICE_TYPE_generic = scs_input_device_type_t(1);

(**
 * @brief Semantical device.
 *
 * The inputs of this device map directly to mixes with the same
 * name the same way the Steam Input works. No binding UI is
 * supported. This allows the device to work without user having
 * to do any configuration however it also means that if the
 * game mixes change, the user will be unable to adjust the binding
 * and a plugin update will be required.
 *
 * Note that only subset of mixes are supported. If mix expression
 * in a fresh controls.sii references something like "semantical.<mixname>?0",
 * then semantical input is likely supported for that mix.
 *)
  SCS_INPUT_DEVICE_TYPE_semantical = scs_input_device_type_t(2);

//@}

(**
 * @brief Maximal number of inputs allowed on a single device.
 *)
  SCS_INPUT_MAX_INPUT_COUNT = scs_u32_t(400);

(**
 * @brief Information about a single input of the input device.
 *)
type
  scs_input_device_input_t = record
    (**
     * @brief Name of this input used in the configuration file
     *
     * This string can contain only the following characters:
     * @li lower-cased english letters
     * @li digits
     * @li underscore
     *)
    name:         scs_string_t;

    (**
     * @brief Name of the input shown to the user.
     *
     * Currently only the following characters are allowed:
     * @li English letters
     * @li digits
     * @li underscore
     * @li space
     * @li dot
     *)
    display_name: scs_string_t;

    (**
     * @brief Type of the value provided by this input.
     *
     * Only the following value types are supported:
     * @li SCS_VALUE_TYPE_bool
     * @li SCS_VALUE_TYPE_float
     *)
    value_type:   scs_value_type_t;

  {$IFDEF SCS_ARCHITECTURE_x64}
    (**
     * @brief Explicit 8-byte alignment for structure size.
     *)
    _padding:     scs_u32_t;               
  {$ENDIF}
  end;
  p_scs_input_device_input_t = ^scs_input_device_input_t;

(**
 * @brief Type of function called to notify about changes in device activity state
 *
 * @param active Nonzero if the device is active and processing events.
 * @param context Context information passed during device registration.
 *)
  scs_input_active_callback_t = procedure(active: scs_u8_t; context: scs_context_t); {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Input device.
 *)
  scs_input_device_t = record
    (**
     * @brief Name of this device used in the configuration file
     *
     * Must be unique among all input plugins.
     *
     * This string can contain only the following characters:
     * @li lower-cased English letters
     * @li digits
     * @li underscore
     *)
    name:                   scs_string_t;

    (**
     * @brief Name of the device shown to the user.
     *
     * Currently only the following characters are allowed:
     * @li English letters
     * @li digits
     * @li underscore
     * @li space
     * @li dot
     *)
    display_name:           scs_string_t;

    (**
     * @brief Type of this device.
     *)
    _type:                  scs_input_device_type_t;

    (**
     * @brief Number of inputs in the inputs array.
     *
     * There must be at least one input.
     *)
    input_count:            scs_u32_t;

    (**
     * @brief Individual inputs.
     *)
    inputs:                 p_scs_input_device_input_t;

    (**
     * @brief Context value to provide to the callbacks.
     *)
    callback_context:       scs_context_t;

    (**
     * @brief Callback called when device activity state changes
     *
     * Optional
     *)
    input_active_callback:  scs_input_active_callback_t;

    (**
     * @brief Callback to call to retrieve input events.
     *
     * Only called when the device is active.
     *
     * Required
     *)
    input_event_callback:   scs_input_event_callback_t;
  end;
  p_scs_input_device_t = ^scs_input_device_t;

(**
 * @brief Registers a input device
 *
 * This function can be only called from scs_input_init. Devices are automatically unregistered before
 * calling scs_input_shutdown.
 *
 * @param device_info Information about the device. The structure is fully processed during the call.
 * @return SCS_RESULT_ok on successful registration. Error code otherwise.
 *)
  scs_input_register_device_t = Function(device_info: p_scs_input_device_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(*</interface>*)

implementation

{$IFDEF AssertTypeSize}
initialization
(*<initialization>*)
  Assert(scs_check_size(SizeOf(scs_input_device_input_t),12,24));
  Assert(scs_check_size(SizeOf(scs_input_device_t),32,56));
(*</initialization>*)
{$ENDIF}

(*</unit>*)
end.
