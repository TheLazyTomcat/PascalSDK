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

  Last changed 2023-02-02

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
unit PascalSDK;

{$IF defined(CPUX86_64) or defined(CPUX64)}
  {$DEFINE SCS_ARCHITECTURE_x64}
{$ELSEIF defined(CPU386)}
  {$DEFINE SCS_ARCHITECTURE_x86}
{$ELSE}
  {$MESSAGE Fatal 'Unsupported CPU architecture'}
{$IFEND}

{$IF Defined(WINDOWS) or Defined(MSWINDOWS)}
  {$DEFINE Windows}
{$IFEND}

{$IFDEF FPC}
  {$MODE ObjFPC}
  {$INLINE ON}
  {$DEFINE CanInline}
{$ELSE}
  {$IF CompilerVersion >= 17 then}  // Delphi 2005+
    {$DEFINE CanInline}
  {$ELSE}
    {$UNDEF CanInline}
  {$IFEND}
{$ENDIF}
{$H+}

{$IFDEF Debug}
  {$DEFINE AssertTypeSize}
{$ELSE}
  {$UNDEF AssertTypeSize}
{$ENDIF}

interface

uses
  AuxTypes, StrRect; 

{-------------------------------------------------------------------------------
  scssdk.pas
-------------------------------------------------------------------------------}

{
  SDKString

  String type intended to hold strings for/from the API in a pascal-friendly
  way (that is as managed, reference counted, copy-on-write string).
}
type
  SDKString = type UTF8String;

  // Types used trough the SDK.
  scs_u8_t  = UInt8;          p_scs_u8_t  = ^scs_u8_t;
  scs_u16_t = UInt16;         p_scs_u16_t = ^scs_u16_t;
  scs_s32_t = Int32;          p_scs_s32_t = ^scs_s32_t;
  scs_u32_t = UInt32;         p_scs_u32_t = ^scs_u32_t;
  scs_s64_t = Int64;          p_scs_s64_t = ^scs_s64_t;
  scs_u64_t = UInt64;         p_scs_u64_t = ^scs_u64_t;

  scs_float_t  = Float32;     p_scs_float_t  = ^scs_float_t;
  scs_double_t = Float64;     p_scs_double_t = ^scs_double_t;
  
  scs_string_t = PUTF8Char;   p_scs_string_t = ^scs_string_t;

const
  SCS_U32_NIL = scs_u32_t(-1);

(**
 * @brief Type of value provided during callback registration and passed back
 * to the callback.
 *)
type
  scs_context_t = Pointer;
  p_scs_context_t = ^scs_context_t;

(**
 * @brief Timestamp value.
 *
 * Value is expressed in microseconds.
 *)
  scs_timestamp_t = scs_u64_t;
  p_scs_timestamp_t = ^scs_timestamp_t;

// Common return codes.
  scs_result_t = scs_s32_t;
  p_scs_result_t = ^scs_result_t;

const
  SCS_RESULT_ok                 = scs_result_t(0);  // Operation succeeded.
  SCS_RESULT_unsupported        = scs_result_t(-1); // Operation or specified parameters are not supported. (e.g. the plugin does not support the requested version of the API)
  SCS_RESULT_invalid_parameter  = scs_result_t(-2); // Specified parameter is not valid (e.g. null value of callback, invalid combination of flags).
  SCS_RESULT_already_registered = scs_result_t(-3); // There is already a registered conflicting object (e.g. callback for the specified event/channel, input device with the same name).
  SCS_RESULT_not_found          = scs_result_t(-4); // Specified item (e.g. channel) was not found.
  SCS_RESULT_unsupported_type   = scs_result_t(-5); // Specified value type is not supported (e.g. channel does not provide that value type).
  SCS_RESULT_not_now            = scs_result_t(-6); // Action (event/callback registration) is not allowed in the current state. Indicates incorrect use of the api.
  SCS_RESULT_generic_error      = scs_result_t(-7); // Error not covered by other existing code.

// Types of messages printed to log.
type
  scs_log_type_t = scs_s32_t;
  p_scs_log_type_t = ^scs_log_type_t;

const
  SCS_LOG_TYPE_message = scs_log_type_t(0);
  SCS_LOG_TYPE_warning = scs_log_type_t(1);
  SCS_LOG_TYPE_error   = scs_log_type_t(2);

(**
 * @brief Logs specified message to the game log.
 *
 * @param type Type of message. Controls generated prefixes and colors in console.
 * @param message Message to log.
 *)
type
  scs_log_t = procedure(_type: scs_log_type_t; _message: scs_string_t); {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

// Common initialization structures.

(**
 * @brief Initialization parameters common to most APIs provided
 * by the SDK.
 *)
  scs_sdk_init_params_v100_t = record
    (**
     * @brief Name of the game for display purposes.
     *
     * This is UTF8 encoded string containing name of the game
     * for display to the user. The exact format is not defined,
     * might be changed between versions and should be not parsed.
     *
     * This pointer will be never NULL.
     *)
    game_name:    scs_string_t;

    (**
     * @brief Identification of the game.
     *
     * If the library wants to identify the game to do any
     * per-game configuration, this is the field which should
     * be used.
     *
     * This string contains only following characters:
     * @li lower-cased letters
     * @li digits
     * @li underscore
     *
     * This pointer will be never NULL.
     *)
    game_id:      scs_string_t;

    (**
     * @brief Version of the game for purpose of the specific api
     * which is being initialized.
     *
     * Does NOT match the patch level of the game.
     *)
    game_version: scs_u32_t;

  {$IFDEF SCS_ARCHITECTURE_x64}
    (**
     * @brief Explicit alignment for the 64 bit pointer.
     *)
    _padding:     scs_u32_t;
  {$ENDIF}
  
    (**
     * @brief Function used to write messages to the game log.
     *
     * Each message is printed on a separate line.
     *
     * This pointer will be never NULL.
     *)
    log:          scs_log_t;
  end;
  p_scs_sdk_init_params_v100_t = ^scs_sdk_init_params_v100_t;

// Routines replacing some of the C macros functionality.
Function scs_check_size(actual,expected_32,expected_64: TMemSize): Boolean;{$IFDEF CanInline} inline;{$ENDIF}

Function SCS_MAKE_VERSION(major, minor: scs_u16_t): scs_u32_t;{$IFDEF CanInline} inline;{$ENDIF}
Function SCS_GET_MAJOR_VERSION(version: scs_u32_t): scs_u16_t;{$IFDEF CanInline} inline;{$ENDIF}
Function SCS_GET_MINOR_VERSION(version: scs_u32_t): scs_u16_t;{$IFDEF CanInline} inline;{$ENDIF}
Function SCS_VERSION_AS_STRING(version: scs_u32_t): String;

//------------------------------------------------------------------------------
// Routines for API strings conversions.

{
  APIString

  Since scs_string_t is just a pointer, APIString does only casting to pointer
  and then returns it. No new memory is allocated (do NOT attempt to free the
  returned pointer).

  Use this function to pass static strings to the API.
}
Function APIString(const Str: SDKString): scs_string_t; overload;{$IFDEF CanInline} inline;{$ENDIF}

{
  APIStringToSDKString

  Creates new variable of type SDKString, fills it with content of Str and then
  returns it.
  If the Str parameter is not assigned or is empty, then it will return an
  empty string.

  Use this function if you want to store strings returned from the API for
  later use.
}
Function APIStringToSDKString(const Str: scs_string_t): SDKString;

{
  SDKStringToAPIString

  Allocates new memory, fills it with content of Str and then returns pointer
  to it.

    WARNING - allocated memory must be explicitly freed using APIStringFree.

  If the Str is an empty string, then this function will return a nil (null)
  pointer.

  Use of this function is limited at this moment, it is here for the sake of
  completeness and a possible future use.
}
Function SDKStringToAPIString(const Str: SDKString): scs_string_t;

{
  SDKStringToAPIString

  Frees memory allocated by SDKStringToAPIString and sets the pointer to nil.
}
procedure APIStringFree(var Str: scs_string_t);

{
  SDKStringDecode

  Converts SDKString type to default string type.

  As default strings can be widly different depending on compiler, its version,
  used component library and other things, never do direct assignment between
  SDKString type and String type, always do the conversion.
}
Function SDKStringDecode(const Str: SDKString): String;{$IFDEF CanInline} inline;{$ENDIF}

{
  SDKStringEncode

  Converts default string type to SDKString type.
}
Function SDKStringEncode(const Str: String): SDKString;{$IFDEF CanInline} inline;{$ENDIF}

{-------------------------------------------------------------------------------
  scssdk_value.pas
-------------------------------------------------------------------------------}

type
  scs_value_type_t = scs_u32_t;
  p_scs_value_type_t = ^scs_value_type_t;

const
  SCS_VALUE_TYPE_INVALID    = scs_value_type_t(0);
  SCS_VALUE_TYPE_bool       = scs_value_type_t(1);
  SCS_VALUE_TYPE_s32        = scs_value_type_t(2);
  SCS_VALUE_TYPE_u32        = scs_value_type_t(3);
  SCS_VALUE_TYPE_u64        = scs_value_type_t(4);
  SCS_VALUE_TYPE_float      = scs_value_type_t(5);
  SCS_VALUE_TYPE_double     = scs_value_type_t(6);
  SCS_VALUE_TYPE_fvector    = scs_value_type_t(7);
  SCS_VALUE_TYPE_dvector    = scs_value_type_t(8);
  SCS_VALUE_TYPE_euler      = scs_value_type_t(9);
  SCS_VALUE_TYPE_fplacement = scs_value_type_t(10);
  SCS_VALUE_TYPE_dplacement = scs_value_type_t(11);
  SCS_VALUE_TYPE_string     = scs_value_type_t(12);
  SCS_VALUE_TYPE_s64        = scs_value_type_t(13);
  SCS_VALUE_TYPE_LAST       = SCS_VALUE_TYPE_s64;

(**
 * @name Simple data types.
 *)
//@{
type
  scs_value_bool_t = record
    value:  scs_u8_t; //< Nonzero value is true, zero false.
  end;
  p_scs_value_bool_t = ^scs_value_bool_t;

  scs_value_s32_t = record
    value:  scs_s32_t;
  end;
  p_scs_value_s32_t = ^scs_value_s32_t;

  scs_value_u32_t = record
    value:  scs_u32_t;
  end;
  p_scs_value_u32_t = ^scs_value_u32_t;

  scs_value_u64_t = record
    value:  scs_u64_t;
  end;
  p_scs_value_u64_t = ^scs_value_u64_t;

  scs_value_s64_t = record
    value:  scs_s64_t;
  end;
  p_scs_value_s64_t = ^scs_value_s64_t;

  scs_value_float_t = record
    value:  scs_float_t;
  end;
  p_scs_value_float_t = ^scs_value_float_t;

  scs_value_double_t = record
    value:  scs_double_t;
  end;
  p_scs_value_double_t = ^scs_value_double_t;
//@}

(**
 * @brief String value.
 *
 * The provided value is UTF8 encoded however in some documented
 * cases only limited ASCII compatible subset might be present.
 *
 * The pointer is never NULL.
 *)
  scs_value_string_t = record
    value:  scs_string_t;
  end;
  p_scs_value_string_t = ^scs_value_string_t;

(**
 * @name Vector types.
 *
 * In local space the X points to right, Y up and Z backwards.
 * In world space the X points to east, Y up and Z south.
 *)
//@{
  scs_value_fvector_t = record
    x:  scs_float_t;
    y:  scs_float_t;
    z:  scs_float_t;
  end;
  p_scs_value_fvector_t = ^scs_value_fvector_t;

  scs_value_dvector_t = record
    x:  scs_double_t;
    y:  scs_double_t;
    z:  scs_double_t;
  end;
  p_scs_value_dvector_t = ^scs_value_dvector_t;
//@}

(**
 * @brief Orientation of object.
 *)
  scs_value_euler_t = record
    (**
     * @brief Heading.
     *
     * Stored in unit range where <0,1) corresponds to <0,360).
     *
     * The angle is measured counterclockwise in horizontal plane when looking
     * from top where 0 corresponds to forward (north), 0.25 to left (west),
     * 0.5 to backward (south) and 0.75 to right (east).
     *)
    heading:  scs_float_t;

    (**
     * @brief Pitch
     *
     * Stored in unit range where <-0.25,0.25> corresponds to <-90,90>.
     *
     * The pitch angle is zero when in horizontal direction,
     * with positive values pointing up (0.25 directly to zenith),
     * and negative values pointing down (-0.25 directly to nadir).
     *)
    pitch:    scs_float_t;

    (**
     * @brief Roll
     *
     * Stored in unit range where <-0.5,0.5> corresponds to <-180,180>.
     *
     * The angle is measured in counterclockwise when looking in direction of
     * the roll axis.
     *)
    roll:     scs_float_t;
  end;
  p_scs_value_euler_t = ^scs_value_euler_t;

(**
 * @name Combination of position and orientation.
 *)
//@{
  scs_value_fplacement_t = record
    position:     scs_value_fvector_t;
    orientation:  scs_value_euler_t;
  end;
  p_scs_value_fplacement_t = ^scs_value_fplacement_t;

  scs_value_dplacement_t = record
    position:     scs_value_dvector_t;
    orientation:  scs_value_euler_t;
     _padding:    scs_u32_t;  // Explicit padding.
  end;
  p_scs_value_dplacement_t = ^scs_value_dplacement_t;
//@}

(**
 * @brief Varying type storage for values.
 *)
  scs_value_t = record
    (**
     * @brief Type of the value.
     *)
    _type:    scs_value_type_t;   //"type" is reserved word in pascal

    (**
     * @brief Explicit alignment for the union.
     *)
    _padding: scs_u32_t;

    (**
     * @brief Storage.
     *)
    case Integer of
      0:  (value_bool:       scs_value_bool_t);
      1:  (value_s32:        scs_value_s32_t);
      2:  (value_u32:        scs_value_u32_t);
      3:  (value_u64:        scs_value_u64_t);
      4:  (value_s64:        scs_value_s64_t);
      5:  (value_float:      scs_value_float_t);
      6:  (value_double:     scs_value_double_t);
      7:  (value_fvector:    scs_value_fvector_t);
      8:  (value_dvector:    scs_value_dvector_t);
      9:  (value_euler:      scs_value_euler_t);
     10:  (value_fplacement: scs_value_fplacement_t);
     11:  (value_dplacement: scs_value_dplacement_t);
     12:  (value_string:     scs_value_string_t);
  end;
  p_scs_value_t = ^scs_value_t;

(**
 * @brief Combination of value and its name.
 *)
  scs_named_value_t = record
    (**
     * @brief Name of this value.
     *
     * ASCII subset of UTF-8.
     *)
    name:     scs_string_t;

    (**
     * @brief Zero-based index of the value for array-like values.
     *
     * For non-array values it is set to SCS_U32_NIL.
     *)
    index:    scs_u32_t;

  {$IFDEF SCS_ARCHITECTURE_x64}
    (**
     * @brief Explicit 8-byte alignment for the value part.
     *)
    _padding: scs_u32_t;
  {$ENDIF}
  
    (**
     * @brief The value itself.
     *)
    value:    scs_value_t;
  end;
  p_scs_named_value_t = ^scs_named_value_t; 

{-------------------------------------------------------------------------------
  scssdk_telemetry_event.pas
-------------------------------------------------------------------------------}

type
  scs_event_t = scs_u32_t;
  p_scs_event_t = ^scs_event_t;

(**
 * @name Telemetry event types.
 *)
//@{

(**
 * @brief Used to mark invalid value of event type.
 *)
const
  SCS_TELEMETRY_EVENT_invalid = scs_event_t(0);

(**
 * @brief Generated before any telemetry data for current frame.
 *
 * The event_info parameter for this event points to
 * scs_telemetry_frame_start_t structure.
 *)
  SCS_TELEMETRY_EVENT_frame_start = scs_event_t(1);

(**
 * @brief Generated after all telemetry data for current frame.
 *)
  SCS_TELEMETRY_EVENT_frame_end = scs_event_t(2);

(**
 * @brief Indicates that the game entered paused state (e.g. menu)
 *
 * If the recipient generates some form of force feedback effects,
 * it should probably stop them until SCS_TELEMETRY_EVENT_started
 * event is received.
 *
 * After sending this event, the game stop sending telemetry data
 * unless specified otherwise in description of specific telemetry.
 * The frame start and event events are still generated.
 *)
  SCS_TELEMETRY_EVENT_paused = scs_event_t(3);

(**
 * @brief Indicates that the player is now driving.
 *)
  SCS_TELEMETRY_EVENT_started = scs_event_t(4);

(**
 * @brief Provides set of attributes which change only
 * in special situations (e.g. parameters of the vehicle).
 *
 * The event_info parameter for this event points to
 * scs_telemetry_configuration_t structure.
 *
 * The initial configuration info is delivered to the plugin
 * after its scs_telemetry_init() function succeeds and before
 * any other callback is called. If the the plugin is interested
 * in the configuration info, it must register for this event
 * during its initialization call to ensure that it does
 * not miss it. Future changes in configuration are
 * delivered as described in the event sequence below.
 *)
  SCS_TELEMETRY_EVENT_configuration = scs_event_t(5);

(**
 * @brief An event called when a gameplay event such as job finish happens.
 *
 * The event_info parameter for this event points to scs_telemetry_gameplay_event_t structure.
 *)
  SCS_TELEMETRY_EVENT_gameplay = scs_event_t(6);

//@}

// Sequence of events during frame.
//
// @li Optionally one or more CONFIGURATION events if the configuration changed.
// @li Optionally one from PAUSED or STARTED if there was change since last frame.
// @li FRAME_START
// @li Optionally one or more GAMEPLAY events.
// @li Channel callbacks
// @li FRAME_END

(**
 * @brief Indicates that timers providing the frame timing info
 * were restarted since last frame.
 *
 * When timer is restarted, it will start counting from zero.
 *)
  SCS_TELEMETRY_FRAME_START_FLAG_timer_restart = scs_u32_t($00000001);

(**
 * @brief Parameters the for SCS_TELEMETRY_EVENT_frame_start event callback.
 *)
type
  scs_telemetry_frame_start_t = record
    (**
     * @brief Additional information about this event.
     *
     * Combination of SCS_TELEMETRY_FRAME_START_FLAG_* values.
     *)
    flags:                  scs_u32_t;

    (**
     * @brief Explicit alignment for the 64 bit timestamps.
     *)
    _padding:               scs_u32_t;

    (**
     * @brief Time controlling the visualization.
     *
     * Its step changes depending on rendering FPS.
     *)
    render_time:            scs_timestamp_t;

    (**
     * @brief Time controlling the physical simulation.
     *
     * Usually changes with fixed size steps so it oscilates
     * around the render time. This value changes even if the
     * physics simulation is currently paused.
     *)
    simulation_time:        scs_timestamp_t;

    (**
     * @brief Similar to simulation time however it stops
     * when the physics simulation is paused.
     *)
    paused_simulation_time: scs_timestamp_t;
  end;
  p_scs_telemetry_frame_start_t = ^scs_telemetry_frame_start_t;


(**
 * @brief Parameters for the SCS_TELEMETRY_EVENT_configuration event callback.
 *)
  scs_telemetry_configuration_t = record
    (**
     * @brief Set of logically grouped configuration parameters this
     * event describes (e.g. truck configuration, trailer configuration).
     *
     * See SCS_TELEMETRY_CONFIGURATION_ID_* constants for the game in question.
     *
     * This pointer will be never NULL.
     *)
    id:         scs_string_t;

    (**
     * @brief Array of individual attributes.
     *
     * The array is terminated by entry whose name pointer is set to NULL.
     *
     * Names of the attributes are the SCS_TELEMETRY_CONFIG_ATTRIBUTE_* constants
     * for the game in question.
     *
     * This pointer will be never NULL.
     *)
    attributes: p_scs_named_value_t;
  end;
  p_scs_telemetry_configuration_t = ^scs_telemetry_configuration_t;

(**
 * @brief Parameters for the SCS_TELEMETRY_EVENT_gameplay event callback.
 *)
  scs_telemetry_gameplay_event_t = record
    (**
     * @brief The event id.
     *
     * The event ID name - check SCS_TELEMETRY_GAMEPLAY_EVENT_* for possible names.
     *)
    id:         scs_string_t;

    (**
     * @brief Array of individual attributes.
     *
     * The array is terminated by entry whose name pointer is set to NULL.
     *
     * Names of the attributes are the SCS_TELEMETRY_GAMEPLAY_EVENT_ATTRIBUTE_* constants
     * for the game in question.
     *
     * This pointer will be never NULL.
     *)
    attributes: p_scs_named_value_t;
  end;
  p_scs_telemetry_gameplay_event_t = ^scs_telemetry_gameplay_event_t;

(**
 * @brief Type of function registered to be called for event.
 *
 * @param event Event in question. Allows use of single callback with  more than one event.
 * @param event_info Structure with additional event information about the event.
 * @param context Context information passed during callback registration.
 *)
  scs_telemetry_event_callback_t = procedure(event: scs_event_t; event_info: Pointer; context: scs_context_t); {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Registers callback to be called when specified event happens.
 *
 * At most one callback can be registered for each event.
 *
 * This funtion can be called from scs_telemetry_init or from within any
 * event callback other than the callback for the event itself.
 *
 * @param event Event to register for.
 * @param callback Callback to register.
 * @param context Context value passed to the callback.
 * @return SCS_RESULT_ok on successful registration. Error code otherwise.
 *)
  scs_telemetry_register_for_event_t = Function(event: scs_event_t; callback: scs_telemetry_event_callback_t; context: scs_context_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Unregisters callback registered for specified event.
 *
 * This function can be called from scs_telemetry_shutdown, scs_telemetry_init
 * or from within any event callback. Including callback of the event itself.
 * Any event left registered after scs_telemetry_shutdown ends will
 * be unregistered automatically.
 *
 * @param event Event to unregister from.
 * @return SCS_RESULT_ok on successful unregistration. Error code otherwise.
 *)
  scs_telemetry_unregister_from_event_t =  Function(event: scs_event_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

{-------------------------------------------------------------------------------
  scssdk_telemetry_channel.pas
-------------------------------------------------------------------------------}

(**
 * @name Telemetry channel flags.
 *)
//@{

(**
 * @brief No specific flags.
 *)
const
  SCS_TELEMETRY_CHANNEL_FLAG_none = scs_u32_t($00000000);

(**
 * @brief Call the callback even if the value did not change.
 *
 * The default behavior is to only call the callback if the
 * value changes. Note that there might be some special situations
 * where the callback might be called even if the value did not
 * change and this flag is not present. For example when the
 * provider of the channel value is reconfigured or when the value
 * changes so frequently that filtering would be only waste of time.
 *
 * Note that even this flag does not guarantee that the
 * callback will be called. For example it might be not called
 * when the value is currently unavailable and the
 * SCS_TELEMETRY_CHANNEL_FLAG_no_value flag was not provided.
 *)
  SCS_TELEMETRY_CHANNEL_FLAG_each_frame = scs_u32_t($00000001);

(**
 * @brief Call the callback even if the value is currently
 * unavailable.
 *
 * By default the callback is only called when the value is
 * available. If this flag is specified, the callback will be
 * called even when the value is unavailable. In that case
 * the value parameter of the callback will be set to NULL.
 *)
  SCS_TELEMETRY_CHANNEL_FLAG_no_value = scs_u32_t($00000002);

//@}

(**
 * @brief Type of function registered to be called with value of single telemetry channel.
 *
 * @param name Name of the channel. Intended for debugging purposes only.
 * @param index Index of entry for array-like channels.
 * @param value Current value of the channel. Will use the type provided during the registration.
 *        Will be NULL if and only if the SCS_TELEMETRY_CHANNEL_FLAG_no_value flag was specified
 *        during registration and the value is currently unavailable.
 * @param context Context information passed during callback registration.
 *)
type
  scs_telemetry_channel_callback_t = procedure(name: scs_string_t; index: scs_u32_t; value: p_scs_value_t; context: scs_context_t); {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Registers callback to be called with value of specified telemetry channel.
 *
 * At most one callback can be registered for each combination of channel name, index and type.
 *
 * Note that order in which the registered callbacks are called is undefined.
 *
 * This funtion can be called from scs_telemetry_init or from within any
 * event (NOT channel) callback.
 *
 * @param name Name of channel to register to.
 * @param index Index of entry for array-like channels. Set to SCS_U32_NIL for normal channels.
 * @param type Desired type of the value. Only some types are supported (see documentation of specific channel). If the channel can not be returned using that type a SCS_RESULT_unsupported_type will be returned.
 * @param flags Flags controlling delivery of the channel.
 * @param callback Callback to register.
 * @param context Context value passed to the callback.
 * @return SCS_RESULT_ok on successful registration. Error code otherwise.
 *)
  scs_telemetry_register_for_channel_t = Function(name: scs_string_t; index: scs_u32_t; _type: scs_value_type_t; flags: scs_u32_t;
    callback: scs_telemetry_channel_callback_t; context: scs_context_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Unregisters callback registered for specified telemetry channel.
 *
 * This function can be called from scs_telemetry_shutdown, scs_telemetry_init
 * or from within any event (NOT channel) callback. Any channel left registered
 * after scs_telemetry_shutdown ends will be unregistered automatically.
 *
 * @param name Name of channel to register from.
 * @param index Index of entry for array-like channels. Set to SCS_U32_NIL for normal channels.
 * @param type Type of value to unregister from.
 * @return SCS_RESULT_ok on successful unregistration. Error code otherwise.
 *)
  scs_telemetry_unregister_from_channel_t = Function(name: scs_string_t; index: scs_u32_t; _type: scs_value_type_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

{-------------------------------------------------------------------------------
  scssdk_telemetry.pas
-------------------------------------------------------------------------------}

(**
 * @name Versions of the telemetry SDK
 *
 * Changes in the major version indicate incompatible changes in the API.
 * Changes in the minor version indicate additions (e.g. more events, defined
 * types as long layout of existing fields in scs_value_t does not change).
 *
 * 1.01 version - added s64 type support, added gameplay events
 *)
//@{
const
  SCS_TELEMETRY_VERSION_1_00    = scs_u32_t((1 shl 16) or 0){0x00010000};
  SCS_TELEMETRY_VERSION_1_01    = scs_u32_t((1 shl 16) or 1){0x00010001};
  SCS_TELEMETRY_VERSION_CURRENT = SCS_TELEMETRY_VERSION_1_01;
//@}

// Structures used to pass additional data to the initialization function.

(**
 * @brief Common ancestor to all structures providing parameters to the telemetry
 * initialization.
 *)
{
  No working analog in pascal for the original code.

type
  scs_telemetry_init_params_t = record
    procedure method_indicating_this_is_not_a_c_struct;
  end;
  p_scs_telemetry_init_params_t = ^scs_telemetry_init_params_t;
}

(**
 * @brief Initialization parameters for the 1.00 version of the telemetry API.
 *)
type
  scs_telemetry_init_params_v100_t = record
    (**
     * @brief Common initialization parameters.
     *)
      common:                   scs_sdk_init_params_v100_t;

    (**
     * @name Functions used to handle registration of event callbacks.
     *)
    //@{
      register_for_event:       scs_telemetry_register_for_event_t;
      unregister_from_event:    scs_telemetry_unregister_from_event_t;
    //@}

    (**
     * @name Functions used to handle registration of telemetry callbacks.
     *)
    //@{
      register_for_channel:     scs_telemetry_register_for_channel_t;
      unregister_from_channel:  scs_telemetry_unregister_from_channel_t;
    //@}
  end;
  p_scs_telemetry_init_params_v100_t = ^scs_telemetry_init_params_v100_t;

(**
 * @brief Initialization parameters for the 1.01 version of the telemetry API.
 *)
  scs_telemetry_init_params_v101_t = scs_telemetry_init_params_v100_t;
  p_scs_telemetry_init_params_v101_t = ^scs_telemetry_init_params_v101_t;

  scs_telemetry_init_params_t = scs_telemetry_init_params_v101_t;
  p_scs_telemetry_init_params_t = ^scs_telemetry_init_params_t;

// Functions which should be exported by the dynamic library serving as
// recipient of the telemetry.

(**
 * @brief Initializes telemetry support.
 *
 * This function must be provided by the library if it wants to support telemetry API.
 *
 * The engine will call this function with API versions it supports starting from the latest
 * until the function returns SCS_RESULT_ok or error other than SCS_RESULT_unsupported or it
 * runs out of supported versions.
 *
 * At the time this function is called, the telemetry is in the paused state.
 *
 * @param version Version of the API to initialize.
 * @param params Structure with additional initialization data specific to the specified API version.
 * @return SCS_RESULT_ok if version is supported and library was initialized. Error code otherwise.
 *)
  scs_telemetry_init = Function(version: scs_u32_t; params: p_scs_telemetry_init_params_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

(**
 * @brief Shuts down the telemetry support.
 *
 * The engine will call this function if available and if the scs_telemetry_init indicated
 * success.
 *)
  scs_telemetry_shutdown = procedure; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

{-------------------------------------------------------------------------------
  scssdk_input_event.pas
-------------------------------------------------------------------------------}

(**
 * @brief Information about a input event.
 *)
type
  scs_input_event_t = record
    (**
     * @brief Zero-based index of input this event is for.
     *)
    input_index:  scs_u32_t;

    (**
     * @brief The event value.
     *
     * Must use the value type corresponding to the value_type the input was registered with.
     *)
    case Integer of
      0:  (value_bool:                    scs_value_bool_t);
      1:  (value_float:                   scs_value_float_t);
      2:  (_sizing_for_future_extensions: array[0..5] of Single);
  end;
  p_scs_input_event_t = ^scs_input_event_t;

(**
 * @brief Indicates that this is the first call of this callback for the current device in the current frame.
 *)
const
  SCS_INPUT_EVENT_CALLBACK_FLAG_first_in_frame = scs_u32_t($00000001);

(**
 * @brief Indicates that this is the first call of this callback after device became active.
 *
 * When this flag is set, the first_in_frame flag will be set as well.
 *)
  SCS_INPUT_EVENT_CALLBACK_FLAG_first_after_activation = scs_u32_t($00000002);

(**
 * @brief Type of function called to retrieve next event from the input device
 *
 * This function is called on the main thread and must be quick. In each frame where the
 * device is active, this function will be called repeatedly until it returns SCS_RESULT_not_found.
 *
 * @param[out] event_info Store the event info here. Ignored if the function returns anything other than SCS_RESULT_ok.
 * @param flags Combination of relevant SCS_INPUT_EVENT_CALLBACK_FLAG_* flags.
 * @param context Context information passed during device registration.
 * @return SCS_RESULT_ok when event was retrieved, SCS_RESULT_not_found when there was no event. Any other value
 *         will disconnect the device and prevent future related callbacks.
 *)
type
  scs_input_event_callback_t = Function(event_info: p_scs_input_event_t; flags: scs_u32_t; context: scs_context_t): scs_result_t; {$IFDEF Windows}stdcall{$ELSE}cdecl{$ENDIF};

{-------------------------------------------------------------------------------
  scssdk_input_device.pas
-------------------------------------------------------------------------------}

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

{-------------------------------------------------------------------------------
  scssdk_input.pas
-------------------------------------------------------------------------------}

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

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_common_configs.pas
-------------------------------------------------------------------------------}

(**
 * @brief The count of the trailers supported by SDK.
 *
 * The maximum number of trailers that can be returned by the telemetry SDK.
 *)
const
  SCS_TELEMETRY_trailers_count = 10;

(**
 * @brief Configuration of the substances.
 *
 * Attribute index is index of the substance.
 *
 * Supported attributes:
 * @li id
 * TODO: Whatever additional info necessary.
 *)
  SCS_TELEMETRY_CONFIG_substances = SDKString('substances');

(**
 * @brief Static configuration of the controls.
 *
 * @li shifter_type
 *)
  SCS_TELEMETRY_CONFIG_controls = SDKString('controls');

(**
 * @brief Configuration of the h-shifter.
 *
 * When evaluating the selected gear, find slot which matches
 * the handle position and bitmask of on/off state of selectors.
 * If one is found, it contains the resulting gear. Otherwise
 * a neutral is assumed.
 *
 * Supported attributes:
 * @li selector_count
 * @li resulting gear index for each slot
 * @li handle position index for each slot
 * @li bitmask of selectors for each slot
 *)
  SCS_TELEMETRY_CONFIG_hshifter = SDKString('hshifter');

(**
 * @brief Static configuration of the truck.
 *
 * If empty set of attributes is returned, there is no configured truck.
 *
 * Supported attributes:
 * @li brand_id
 * @li brand
 * @li id
 * @li name
 * @li fuel_capacity
 * @li fuel_warning_factor
 * @li adblue_capacity
 * @li ablue_warning_factor
 * @li air_pressure_warning
 * @li air_pressure_emergency
 * @li oil_pressure_warning
 * @li water_temperature_warning
 * @li battery_voltage_warning
 * @li rpm_limit
 * @li foward_gear_count
 * @li reverse_gear_count
 * @li retarder_step_count
 * @li cabin_position
 * @li head_position
 * @li hook_position
 * @li license_plate
 * @li license_plate_country
 * @li license_plate_country_id
 * @li wheel_count
 * @li wheel positions for wheel_count wheels
 *)
  SCS_TELEMETRY_CONFIG_truck = SDKString('truck');

(**
 * @brief Backward compatibility static configuration of the first trailer (attributes are equal to trailer.0).
 *
 * The trailers configurations are returned using trailer.[index]
 * (e.g. trailer.0, trailer.1, ... trailer.9 ...)
 *
 * SDK currently can return up to @c SCS_TELEMETRY_trailers_count trailers.
 *
 * If there are less trailers in game than @c SCS_TELEMETRY_trailers_count
 * telemetry will return all configurations however starting from the trailer after last
 * existing one its attributes will be empty.
 *
 * Supported attributes:
 * @li id
 * @li cargo_accessory_id
 * @li hook_position
 * @li brand_id
 * @li brand
 * @li name
 * @li chain_type (reported only for first trailer)
 * @li body_type (reported only for first trailer)
 * @li license_plate
 * @li license_plate_country
 * @li license_plate_country_id
 * @li wheel_count
 * @li wheel offsets for wheel_count wheels
 *)
  SCS_TELEMETRY_CONFIG_trailer = SDKString('trailer');

(**
 * @brief Static configuration of the job.
 *
 * If empty set of attributes is returned, there is no job.
 *
 * Supported attributes:
 * @li cargo_id
 * @li cargo
 * @li cargo_mass
 * @li destination_city_id
 * @li destination_city
 * @li source_city_id
 * @li source_city
 * @li destination_company_id (only available for non special transport jobs)
 * @li destination_company (only available for non special transport jobs)
 * @li source_company_id (only available for non special transport jobs)
 * @li source_company (only available for non special transport jobs)
 * @li income - represents expected income for the job without any penalties
 * @li delivery_time
 * @li is_cargo_loaded
 * @li job_market
 * @li special_job
 * @li planned_distance_km
 *)
  SCS_TELEMETRY_CONFIG_job = SDKString('job');

 // Attributes

 (**
 * @brief Brand id for configuration purposes.
 *
 * Limited to C-identifier characters.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_brand_id = SDKString('brand_id');

 (**
 * @brief Brand for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_brand = SDKString('brand');

(**
 * @brief Name for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_id = SDKString('id');

(**
 * @brief Name of cargo accessory for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo_accessory_id = SDKString('cargo.accessory.id');

(**
 * @brief Name of trailer chain type.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_chain_type = SDKString('chain.type');

(**
 * @brief Name of trailer body type.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_body_type = SDKString('body.type');

(**
 * @brief Vehicle license plate.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_license_plate = SDKString('license.plate');

(**
 * @brief The id representing license plate country.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_license_plate_country_id = SDKString('license.plate.country.id');

(**
 * @brief The name of the license plate country.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_license_plate_country = SDKString('license.plate.country');

(**
 * @brief Name for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_name = SDKString('name');

(**
 * @brief  Fuel tank capacity in litres.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_fuel_capacity = SDKString('fuel.capacity');

(**
 * @brief Fraction of the fuel capacity below which
 * is activated the fuel warning.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_fuel_warning_factor = SDKString('fuel.warning.factor');

(**
 * @brief  AdBlue tank capacity in litres.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_adblue_capacity = SDKString('adblue.capacity');

(**
 * @brief Fraction of the adblue capacity below which
 * is activated the adblue warning.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_adblue_warning_factor = SDKString('adblue.warning.factor');

(**
 * @brief Pressure of the air in the tank below which
 * the warning activates.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_air_pressure_warning = SDKString('brake.air.pressure.warning');

(**
 * @brief Pressure of the air in the tank below which
 * the emergency brakes activate.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_air_pressure_emergency = SDKString('brake.air.pressure.emergency');

(**
 * @brief Pressure of the oil below which the warning activates.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_oil_pressure_warning = SDKString('oil.pressure.warning');

(**
 * @brief Temperature of the water above which the warning activates.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_water_temperature_warning = SDKString('water.temperature.warning');

(**
 * @brief Voltage of the battery below which the warning activates.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_battery_voltage_warning = SDKString('battery.voltage.warning');

(**
 * @brief Maximum rpm value.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_rpm_limit = SDKString('rpm.limit');

(**
 * @brief Number of forward gears on undamaged truck.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_forward_gear_count = SDKString('gears.forward');

(**
 * @brief Number of reversee gears on undamaged truck.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_reverse_gear_count = SDKString('gears.reverse');

(**
 * @brief Differential ratio of the truck.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_differential_ratio = SDKString('differential.ratio');

(**
 * @brief Number of steps in the retarder.
 *
 * Set to zero if retarder is not mounted to the truck.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_retarder_step_count = SDKString('retarder.steps');

(**
 * @brief Forward transmission ratios.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_forward_ratio = SDKString('forward.ratio');

(**
 * @brief Reverse transmission ratios.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_reverse_ratio = SDKString('reverse.ratio');

(**
 * @brief Position of the cabin in the vehicle space.
 *
 * This is position of the joint around which the cabin rotates.
 * This attribute might be not present if the vehicle does not
 * have a separate cabin.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cabin_position = SDKString('cabin.position');

(**
 * @brief Default position of the head in the cabin space.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_head_position = SDKString('head.position');

(**
 * @brief Position of the trailer connection hook in vehicle
 * space.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_hook_position = SDKString('hook.position');

(**
 * @brief Number of wheels
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_count = SDKString('wheels.count');

(**
 * @brief Position of respective wheels in the vehicle space.
 *
 * Type: indexed fvector
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_position = SDKString('wheel.position');

(**
 * @brief Is the wheel steerable?
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_steerable = SDKString('wheel.steerable');

(**
 * @brief Is the wheel physicaly simulated?
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_simulated = SDKString('wheel.simulated');

(**
 * @brief Radius of the wheel
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_radius = SDKString('wheel.radius');

(**
 * @brief Is the wheel powered?
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_powered = SDKString('wheel.powered');

(**
 * @brief Is the wheel liftable?
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_wheel_liftable = SDKString('wheel.liftable');

(**
 * @brief Number of selectors (e.g. range/splitter toggles).
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_selector_count = SDKString('selector.count');

(**
 * @brief Gear selected when requirements for this h-shifter slot are meet.
 *
 * Type: indexed s32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_slot_gear = SDKString('slot.gear');

(**
 * @brief Position of h-shifter handle.
 *
 * Zero corresponds to neutral position. Mapping to physical position of
 * the handle depends on input setup.
 *
 * Type: indexed u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_slot_handle_position = SDKString('slot.handle.position');

(**
 * @brief Bitmask of required on/off state of selectors.
 *
 * Only first selector_count bits are relevant.
 *
 * Type: indexed u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_slot_selectors = SDKString('slot.selectors');

(**
 * @brief Type of the shifter.
 *
 * One from SCS_SHIFTER_TYPE_* values.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_shifter_type = SDKString('shifter.type');

  SCS_SHIFTER_TYPE_arcade    = SDKString('arcade');
  SCS_SHIFTER_TYPE_automatic = SDKString('automatic');
  SCS_SHIFTER_TYPE_manual    = SDKString('manual');
  SCS_SHIFTER_TYPE_hshifter  = SDKString('hshifter');

 // Attributes

 (**
 * @brief Id of the cargo for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo_id = SDKString('cargo.id');

(**
 * @brief Name of the cargo for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo = SDKString('cargo');

(**
 * @brief Mass of the cargo in kilograms.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo_mass = SDKString('cargo.mass');

(**
 * @brief Mass of the single unit of the cargo in kilograms.
 *
 * Type: float
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo_unit_mass = SDKString('cargo.unit.mass');

(**
 * @brief How many units of the cargo the job consist of.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_cargo_unit_count = SDKString('cargo.unit.count');


(**
 * @brief Id of the destination city for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_destination_city_id = SDKString('destination.city.id');

(**
 * @brief Name of the destination city for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_destination_city = SDKString('destination.city');

(**
 * @brief Id of the destination company for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *(
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_destination_company_id = SDKString('destination.company.id');

(**
 * @brief Name of the destination company for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_destination_company = SDKString('destination.company');

(**
 * @brief Id of the source city for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_source_city_id = SDKString('source.city.id');

(**
 * @brief Name of the source city for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_source_city = SDKString('source.city');

(**
 * @brief Id of the source company for internal use by code.
 *
 * Limited to C-identifier characters and dots.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_source_company_id = SDKString('source.company.id');

(**
 * @brief Name of the source company for display purposes.
 *
 * Localized using the current in-game language.
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_source_company = SDKString('source.company');

(**
 * @brief Reward in internal game-specific currency.
 *
 * For detailed information about the currency see "Game specific units"
 * documentation in scssdk_telemetry_<game_id>.h
 *
 * Type: u64
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_income = SDKString('income');

(**
 * @brief Absolute in-game time of end of job delivery window.
 *
 * Delivering the job after this time will cause it be late.
 *
 * See SCS_TELEMETRY_CHANNEL_game_time for more info about absolute time.
 * Time remaining for delivery can be obtained like (delivery_time - game_time).
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_delivery_time = SDKString('delivery.time');

(**
 * @brief Planned job distance in simulated kilometers.
 *
 * Does not include distance driven using ferry.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_planned_distance_km = SDKString('planned_distance.km');

(**
 * @brief Is cargo loaded on the trailer?
 *
 * For non cargo market jobs this is always true
 *
 * Type: bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_is_cargo_loaded = SDKString('cargo.loaded');

(**
 * @brief The job market this job is from.
 *
 * The value is a string representing the type of the job market.
 * Possible values:
 * @li cargo_market
 * @li quick_job
 * @li freight_market
 * @li external_contracts
 * @li external_market
 *
 * Type: string
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_job_market = SDKString('job.market');

(**
 * @brief Flag indicating that the job is special transport job.
 *
 * Type: bool
 *)
  SCS_TELEMETRY_CONFIG_ATTRIBUTE_special_job = SDKString('is.special.job');

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_common_gameplay_events.pas
-------------------------------------------------------------------------------}

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

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_common_channels.pas
-------------------------------------------------------------------------------}

(**
 * @brief Scale applied to distance and time to compensate
 * for the scale of the map (e.g. 1s of real time corresponds to local_scale
 * seconds of simulated game time).
 *
 * Games which use real 1:1 maps will not provide this
 * channel.
 *
 * Type: float
 *)
const
  SCS_TELEMETRY_CHANNEL_local_scale = SDKString('local.scale');

(**
 * @brief Absolute in-game time.
 *
 * Represented in number of in-game minutes since beginning (i.e. 00:00)
 * of the first in-game day.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_CHANNEL_game_time = SDKString('game.time');

(**
 * @brief Offset from the game_time simulated in the local economy to the
 * game time of the Convoy multiplayer server.
 *
 * The value of this channel can change frequently during the Convoy
 * session. For example when the user enters the desktop, the local
 * economy time stops however the multiplayer time continues to run
 * so the value will start to change.
 *
 * Represented in in-game minutes. Set to 0 when multiplayer is not active.
 *
 * Type: s32
 *)
  SCS_TELEMETRY_CHANNEL_multiplayer_time_offset = SDKString('multiplayer.time.offset');

(**
 * @brief Time until next rest stop.
 *
 * When the fatique simulation is disabled, the behavior of this channel
 * is implementation dependent. The game might provide the value which would
 * apply if it was enabled or provide no value at all.
 *
 * Represented in in-game minutes.
 *
 * Type: s32
 *)
  SCS_TELEMETRY_CHANNEL_next_rest_stop = SDKString('rest.stop');

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_truck_common_channels.pas
-------------------------------------------------------------------------------}

// Movement.

(**
 * @brief Represents world space position and orientation of the truck.
 *
 * Type: dplacement
 *)
const
  SCS_TELEMETRY_TRUCK_CHANNEL_world_placement = SDKString('truck.world.placement');

(**
 * @brief Represents vehicle space linear velocity of the truck measured
 * in meters per second.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_local_linear_velocity = SDKString('truck.local.velocity.linear');

(**
 * @brief Represents vehicle space angular velocity of the truck measured
 * in rotations per second.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_local_angular_velocity = SDKString('truck.local.velocity.angular');

(**
 * @brief Represents vehicle space linear acceleration of the truck measured
 * in meters per second^2
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_local_linear_acceleration = SDKString('truck.local.acceleration.linear');

 (**
 * @brief Represents vehicle space angular acceleration of the truck meassured
 * in rotations per second^2
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_local_angular_acceleration = SDKString('truck.local.acceleration.angular');

(**
 * @brief Represents a vehicle space position and orientation delta
 * of the cabin from its default position.
 *
 * Type: fplacement
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_cabin_offset = SDKString('truck.cabin.offset');

(**
 * @brief Represents cabin space angular velocity of the cabin measured
 * in rotations per second.
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_cabin_angular_velocity = SDKString('truck.cabin.velocity.angular');

 (**
 * @brief Represents cabin space angular acceleration of the cabin
 * measured in rotations per second^2
 *
 * Type: fvector
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_cabin_angular_acceleration = SDKString('truck.cabin.acceleration.angular');

(**
 * @brief Represents a cabin space position and orientation delta
 * of the driver head from its default position.
 *
 * Note that this value might change rapidly as result of
 * the user switching between cameras or camera presets.
 *
 * Type: fplacement
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_head_offset = SDKString('truck.head.offset');

(**
 * @brief Speedometer speed in meters per second.
 *
 * Uses negative value to represent reverse movement.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_speed = SDKString('truck.speed');

// Powertrain related

(**
 * @brief RPM of the engine.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_engine_rpm = SDKString('truck.engine.rpm');

(**
 * @brief Gear currently selected in the engine.
 *
 * @li >0 - Forwad gears
 * @li 0 - Neutral
 * @li <0 - Reverse gears
 *
 * Type: s32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_engine_gear = SDKString('truck.engine.gear');

(**
 * @brief Gear currently displayed on dashboard.
 *
 * @li >0 - Forwad gears
 * @li 0 - Neutral
 * @li <0 - Reverse gears
 *
 * Type: s32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_displayed_gear = SDKString('truck.displayed.gear');

// Driving

(**
 * @brief Steering received from input <-1;1>.
 *
 * Note that it is interpreted counterclockwise.
 *
 * If the user presses the steer right button on digital input
 * (e.g. keyboard) this value goes immediatelly to -1.0
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_input_steering = SDKString('truck.input.steering');

(**
 * @brief Throttle received from input <0;1>
 *
 * If the user presses the forward button on digital input
 * (e.g. keyboard) this value goes immediatelly to 1.0
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_input_throttle = SDKString('truck.input.throttle');

(**
 * @brief Brake received from input <0;1>
 *
 * If the user presses the brake button on digital input
 * (e.g. keyboard) this value goes immediatelly to 1.0
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_input_brake = SDKString('truck.input.brake');

(**
 * @brief Clutch received from input <0;1>
 *
 * If the user presses the clutch button on digital input
 * (e.g. keyboard) this value goes immediatelly to 1.0
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_input_clutch = SDKString('truck.input.clutch');

(**
 * @brief Steering as used by the simulation <-1;1>
 *
 * Note that it is interpreted counterclockwise.
 *
 * Accounts for interpolation speeds and simulated
 * counterfoces for digital inputs.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_effective_steering = SDKString('truck.effective.steering');

(**
 * @brief Throttle pedal input as used by the simulation <0;1>
 *
 * Accounts for the press attack curve for digital inputs
 * or cruise-control input.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_effective_throttle = SDKString('truck.effective.throttle');

(**
 * @brief Brake pedal input as used by the simulation <0;1>
 *
 * Accounts for the press attack curve for digital inputs. Does
 * not contain retarder, parking or engine brake.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_effective_brake = SDKString('truck.effective.brake');

(**
 * @brief Clutch pedal input as used by the simulation <0;1>
 *
 * Accounts for the automatic shifting or interpolation of
 * player input.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_effective_clutch = SDKString('truck.effective.clutch');

(**
 * @brief Speed selected for the cruise control in m/s
 *
 * Is zero if cruise control is disabled.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_cruise_control = SDKString('truck.cruise_control');

// Gearbox related

(**
 * @brief Gearbox slot the h-shifter handle is currently in.
 *
 * 0 means that no slot is selected.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_hshifter_slot = SDKString('truck.hshifter.slot');

(**
 * @brief Enabled state of range/splitter selector toggles.
 *
 * Mapping between the range/splitter functionality and
 * selector index is described by HSHIFTER configuration.
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_hshifter_selector = SDKString('truck.hshifter.select');

 // Brakes.

(**
 * @brief Is the parking brake enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_parking_brake = SDKString('truck.brake.parking');

(**
 * @brief Is the engine brake enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_motor_brake = SDKString('truck.brake.motor');

(**
 * @brief Current level of the retarder.
 *
 * <0;max> where 0 is disabled retarder and max is maximum
 * value found in TRUCK configuration.
 *
 * Type: u32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_retarder_level = SDKString('truck.brake.retarder');

(**
 * @brief Pressure in the brake air tank in psi
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure = SDKString('truck.brake.air.pressure');

(**
 * @brief Is the air pressure warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_warning = SDKString('truck.brake.air.pressure.warning');

(**
 * @brief Are the emergency brakes active as result of low air pressure?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_brake_air_pressure_emergency = SDKString('truck.brake.air.pressure.emergency');

(**
 * @brief Temperature of the brakes in degrees celsius.
 *
 * Aproximated for entire truck, not at the wheel level.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_brake_temperature = SDKString('truck.brake.temperature');

// Various "consumables"

(**
 * @brief Amount of fuel in liters
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_fuel = SDKString('truck.fuel.amount');

(**
 * @brief Is the low fuel warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_fuel_warning = SDKString('truck.fuel.warning');

(**
 * @brief Average consumption of the fuel in liters/km
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_fuel_average_consumption = SDKString('truck.fuel.consumption.average');

(**
 * @brief Estimated range of truck with current amount of fuel in km
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_fuel_range = SDKString('truck.fuel.range');

(**
 * @brief Amount of AdBlue in liters
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_adblue = SDKString('truck.adblue');

(**
 * @brief Is the low adblue warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_adblue_warning = SDKString('truck.adblue.warning');

(**
 * @brief Average consumption of the adblue in liters/km
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_adblue_average_consumption = SDKString('truck.adblue.consumption.average');

// Oil

(**
 * @brief Pressure of the oil in psi
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure = SDKString('truck.oil.pressure');

(**
 * @brief Is the oil pressure warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_oil_pressure_warning = SDKString('truck.oil.pressure.warning');

(**
 * @brief Temperature of the oil in degrees celsius.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_oil_temperature = SDKString('truck.oil.temperature');

// Temperature in various systems.

(**
 * @brief Temperature of the water in degrees celsius.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature = SDKString('truck.water.temperature');

(**
 * @brief Is the water temperature warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_water_temperature_warning = SDKString('truck.water.temperature.warning');

// Battery

(**
 * @brief Voltage of the battery in volts.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage = SDKString('truck.battery.voltage');

(**
 * @brief Is the battery voltage/not charging warning active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_battery_voltage_warning = SDKString('truck.battery.voltage.warning');

// Enabled state of various elements.

(**
 * @brief Is the electric enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_electric_enabled = SDKString('truck.electric.enabled');

(**
 * @brief Is the engine enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_engine_enabled = SDKString('truck.engine.enabled');

(**
 * @brief Is the left blinker enabled?
 *
 * This represents the logical enable state of the blinker. It
 * it is true as long the blinker is enabled regardless of the
 * physical enabled state of the light (i.e. it does not blink
 * and ignores enable state of electric).
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_lblinker = SDKString('truck.lblinker');

(**
 * @brief Is the right blinker enabled?
 *
 * This represents the logical enable state of the blinker. It
 * it is true as long the blinker is enabled regardless of the
 * physical enabled state of the light (i.e. it does not blink
 * and ignores enable state of electric).
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_rblinker = SDKString('truck.rblinker');

(**
 * @brief Are the hazard warning light enabled?
 *
 * This represents the logical enable state of the hazard warning.
 * It it is true as long it is enabled regardless of the physical
 * enabled state of the light (i.e. it does not blink).
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_hazard_warning = SDKString('truck.hazard.warning');

(**
 * @brief Is the light in the left blinker currently on?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_lblinker = SDKString('truck.light.lblinker');

(**
 * @brief Is the light in the right blinker currently on?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_rblinker = SDKString('truck.light.rblinker');

(**
 * @brief Are the parking lights enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_parking = SDKString('truck.light.parking');

(**
 * @brief Are the low beam lights enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_low_beam = SDKString('truck.light.beam.low');

(**
 * @brief Are the high beam lights enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_high_beam = SDKString('truck.light.beam.high');

(**
 * @brief Are the auxiliary front lights active?
 *
 * Those lights have several intensity levels:
 * @li 1 - dimmed state
 * @li 2 - full state
 *
 * Type: u32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_front = SDKString('truck.light.aux.front');

(**
 * @brief Are the auxiliary roof lights active?
 *
 * Those lights have several intensity levels:
 * @li 1 - dimmed state
 * @li 2 - full state
 *
 * Type: u32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_aux_roof = SDKString('truck.light.aux.roof');

(**
 * @brief Are the beacon lights enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_beacon = SDKString('truck.light.beacon');

(**
 * @brief Is the brake light active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_brake = SDKString('truck.light.brake');

(**
 * @brief Is the reverse light active?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_light_reverse = SDKString('truck.light.reverse');

(**
 * @brief Are the wipers enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wipers = SDKString('truck.wipers');

(**
 * @brief Intensity of the dashboard backlight as factor <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_dashboard_backlight = SDKString('truck.dashboard.backlight');

(**
 * @brief Is the differential lock enabled?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_differential_lock = SDKString('truck.differential_lock');

(**
 * @brief Is the lift axle control set to lifted state?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_lift_axle = SDKString('truck.lift_axle');

(**
 * @brief Is the lift axle indicator lit?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_lift_axle_indicator = SDKString('truck.lift_axle.indicator');

(**
 * @brief Is the trailer lift axle control set to lifted state?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_trailer_lift_axle = SDKString('truck.trailer.lift_axle');

(**
 * @brief Is the trailer lift axle indicator lit?
 *
 * Type: bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_trailer_lift_axle_indicator = SDKString('truck.trailer.lift_axle.indicator');

// Wear info.

(**
 * @brief Wear of the engine accessory as <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wear_engine = SDKString('truck.wear.engine');

(**
 * @brief Wear of the transmission accessory as <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wear_transmission = SDKString('truck.wear.transmission');

(**
 * @brief Wear of the cabin accessory as <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wear_cabin = SDKString('truck.wear.cabin');

(**
 * @brief Wear of the chassis accessory as <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wear_chassis = SDKString('truck.wear.chassis');

(**
 * @brief Average wear across the wheel accessories as <0;1>
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wear_wheels = SDKString('truck.wear.wheels');

(**
 * @brief The value of the odometer in km.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_odometer = SDKString('truck.odometer');

(**
 * @brief The value of truck's navigation distance (in meters).
 *
 * This is the value used by the advisor.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_navigation_distance = SDKString('truck.navigation.distance');

(**
 * @brief The value of truck's navigation eta (in second).
 *
 * This is the value used by the advisor.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_navigation_time = SDKString('truck.navigation.time');

(**
 * @brief The value of truck's navigation speed limit (in m/s).
 *
 * This is the value used by the advisor and respects the
 * current state of the "Route Advisor speed limit" option.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_navigation_speed_limit = SDKString('truck.navigation.speed.limit');

// Wheels.

(**
 * @brief Vertical displacement of the wheel from its
 * axis in meters.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_susp_deflection = SDKString('truck.wheel.suspension.deflection');

(**
 * @brief Is the wheel in contact with ground?
 *
 * Type: indexed bool
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_on_ground = SDKString('truck.wheel.on_ground');

(**
 * @brief Substance below the whell.
 *
 * Index of substance as delivered trough SUBSTANCE config.
 *
 * Type: indexed u32
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_substance = SDKString('truck.wheel.substance');

(**
 * @brief Angular velocity of the wheel in rotations per
 * second.
 *
 * Positive velocity corresponds to forward movement.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_velocity = SDKString('truck.wheel.angular_velocity');

(**
 * @brief Steering rotation of the wheel in rotations.
 *
 * Value is from <-0.25,0.25> range in counterclockwise direction
 * when looking from top (e.g. 0.25 corresponds to left and
 * -0.25 corresponds to right).
 *
 * Set to zero for non-steered wheels.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_steering = SDKString('truck.wheel.steering');

(**
 * @brief Rolling rotation of the wheel in rotations.
 *
 * Value is from <0.0,1.0) range in which value
 * increase corresponds to forward movement.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_rotation = SDKString('truck.wheel.rotation');

(**
 * @brief Lift state of the wheel <0;1>
 *
 * For use with simple lifted/non-lifted test or logical
 * visualization of the lifting progress.
 *
 * Value of 0 corresponds to non-lifted axle.
 * Value of 1 corresponds to fully lifted axle.
 *
 * Set to zero or not provided for non-liftable axles.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_lift = SDKString('truck.wheel.lift');

(**
 * @brief Vertical displacement of the wheel axle
 * from its normal position in meters as result of
 * lifting.
 *
 * Might have non-linear relation to lift ratio.
 *
 * Set to zero or not provided for non-liftable axles.
 *
 * Type: indexed float
 *)
  SCS_TELEMETRY_TRUCK_CHANNEL_wheel_lift_offset = SDKString('truck.wheel.lift.offset');

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_trailer_common_channels.pas
-------------------------------------------------------------------------------}

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
  SCS_TELEMETRY_TRAILER_CHANNEL_connected = SDKString('trailer.connected');

(**
 * @brief How much is the cargo damaged that is loaded to this trailer in <0.0, 1.0> range.
 *
 * Type: float
 *)
  SCS_TELEMETRY_TRAILER_CHANNEL_cargo_damage = SDKString('trailer.cargo.damage');

(**
 * @name Channels similar to the truck ones
 *
 * See scssdk_telemetry_truck_common_channels.h for description of
 * corresponding truck channels
 *)
//@{
  SCS_TELEMETRY_TRAILER_CHANNEL_world_placement             = SDKString('trailer.world.placement');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_velocity       = SDKString('trailer.velocity.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_velocity      = SDKString('trailer.velocity.angular');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_linear_acceleration   = SDKString('trailer.acceleration.linear');
  SCS_TELEMETRY_TRAILER_CHANNEL_local_angular_acceleration  = SDKString('trailer.acceleration.angular');

// Damage.

  SCS_TELEMETRY_TRAILER_CHANNEL_wear_body    = SDKString('trailer.wear.body');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_chassis = SDKString('trailer.wear.chassis');
  SCS_TELEMETRY_TRAILER_CHANNEL_wear_wheels  = SDKString('trailer.wear.wheels');

// Wheels.

  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_susp_deflection = SDKString('trailer.wheel.suspension.deflection');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_on_ground       = SDKString('trailer.wheel.on_ground');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_substance       = SDKString('trailer.wheel.substance');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_velocity        = SDKString('trailer.wheel.angular_velocity');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_steering        = SDKString('trailer.wheel.steering');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_rotation        = SDKString('trailer.wheel.rotation');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift            = SDKString('trailer.wheel.lift');
  SCS_TELEMETRY_TRAILER_CHANNEL_wheel_lift_offset     = SDKString('trailer.wheel.lift.offset');
//@}

{-------------------------------------------------------------------------------
  common/scssdk_telemetry_job_common_channels.pas
-------------------------------------------------------------------------------}

(**
 * @brief The total damage of the cargo in range 0.0 to 1.0.
 *
 * Type: float
 *)
const
  SCS_TELEMETRY_JOB_CHANNEL_cargo_damage = SDKString('job.cargo.damage');

{-------------------------------------------------------------------------------
  eurotrucks2/scssdk_telemetry_eut2.pas
-------------------------------------------------------------------------------}

(**
 * @name Value used in the scs_sdk_init_params_t::game_version
 *
 * Changes in the major version indicate incompatible changes (e.g. changed interpretation
 * of the channel value). Change of major version is highly discouraged, creation of
 * alternative channel is preferred solution if necessary.
 * Changes in the minor version indicate compatible changes (e.g. added channel, more supported
 * value types). Removal of channel is also compatible change however it is recommended
 * to keep the channel with some default value.
 *
 * Changes:
 * 1.01 - added brake_air_pressure_emergency channel and air_pressure_emergency config
 * 1.02 - replaced cabin_orientation channel with cabin_offset channel
 * 1.03 - fixed reporting of invalid index value for wheels.count attribute
 * 1.04 - added lblinker_light and rblinker_light channels
 * 1.05 - fixed content of brand_id and brand attributes
 * 1.06 - fixed index value for selector_count attribute. It is now SCS_U32_NIL as the
 *        attribute is not indexed. For backward compatibility additional copy with
 *        index 0 is also present however it will be removed in the future.
 * 1.07 - fixed calculation of cabin_angular_acceleration channel.
 * 1.08 - a empty truck/trailer configuration event is generated when truck is removed
 *        (e.g. after completion of quick job)
 * 1.09 - added time and job related info
 * 1.10 - added information about liftable axes
 * 1.11 - u32 channels can provide u64 as documented, added displayed_gear channel, increased
 *        maximum number of supported wheel channels to 14
 * 1.12 - added information about transmission (differential_ratio, forward_ratio, reverse_ratio),
 *        navigation channels (navigation_distance, navigation_time, navigation_speed_limit)
 *        and adblue related data are now provided.
 * 1.13 - fixed values of id and cargo_accessory_id attributes in trailer config broken by
 *        ETS2 1.25 update. Note that the new values will be different from the ones returned
 *        by ETS2 1.24 and older.
 * 1.14 - added support for multiple trailers (doubles, triples), trailer ownership support,
 *        gameplay events support added
 * 1.15 - added planned_distance_km to active job info
 * 1.16 - added support for 'avoid_inspection', 'illegal_border_crossing' and 'hard_shoulder_violation' offence type in 'player.fined' gameplay event
 * 1.17 - added differential lock, lift axle and hazard warning channels
 * 1.18 - added multiplayer time offset and trailer body wear channel, fixed trailer chassis wear channel
 *)
//@{
const
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0) {0x00010000};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_01    = scs_u32_t((1 shl 16) or 1) {0x00010001};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_02    = scs_u32_t((1 shl 16) or 2) {0x00010002};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_03    = scs_u32_t((1 shl 16) or 3) {0x00010003};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_04    = scs_u32_t((1 shl 16) or 4) {0x00010004};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_05    = scs_u32_t((1 shl 16) or 5) {0x00010005};  // Patch 1.4
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_06    = scs_u32_t((1 shl 16) or 6) {0x00010006};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_07    = scs_u32_t((1 shl 16) or 7) {0x00010007};  // Patch 1.6
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_08    = scs_u32_t((1 shl 16) or 8) {0x00010008};  // Patch 1.9
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_09    = scs_u32_t((1 shl 16) or 9) {0x00010009};  // Patch 1.14 beta
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_10    = scs_u32_t((1 shl 16) or 10){0x0001000A};  // Patch 1.14
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_11    = scs_u32_t((1 shl 16) or 11){0x0001000B};
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_12    = scs_u32_t((1 shl 16) or 12){0x0001000C};  // Patch 1.17
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_13    = scs_u32_t((1 shl 16) or 13){0x0001000D};  // Patch 1.27
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_14    = scs_u32_t((1 shl 16) or 14){0x0001000E};  // Patch 1.35
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_15    = scs_u32_t((1 shl 16) or 15){0x0001000F};  // Patch 1.36
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_16    = scs_u32_t((1 shl 16) or 16){0x00010010};  // Patch 1.36
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_17    = scs_u32_t((1 shl 16) or 17){0x00010011};  // Patch 1.41
  SCS_TELEMETRY_EUT2_GAME_VERSION_1_18    = scs_u32_t((1 shl 16) or 18){0x00010012};  // Patch 1.45
  SCS_TELEMETRY_EUT2_GAME_VERSION_CURRENT = SCS_TELEMETRY_EUT2_GAME_VERSION_1_18;
//@}

// Game specific units.
//
// @li The game uses Euro as internal currency provided
//     by the telemetry unless documented otherwise.

// Channels defined in scssdk_telemetry_common_channels.h,
// scssdk_telemetry_job_common_channels.h,
// scssdk_telemetry_truck_common_channels.h and
// scssdk_telemetry_trailer_common_channels.h are supported
// with following exceptions and limitations as of v1.00:
//
// @li Rolling rotation of trailer wheels is determined from linear
//     movement.
// @li The pressures, temperatures and voltages are not simulated.
//     They are very loosely approximated.

// Configurations defined in scssdk_telemetry_common_configs.h are
// supported with following exceptions and limitations as of v1.00:
//
// @li The localized strings are not updated when different in-game
//     language is selected.

{-------------------------------------------------------------------------------
  eurotrucks2/scssdk_input_eut2.pas
-------------------------------------------------------------------------------}

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

{-------------------------------------------------------------------------------
  eurotrucks2/scssdk_eut2.pas
-------------------------------------------------------------------------------}

(**
 * @brief Value used in the scs_sdk_init_params_t::game_id to identify this game.
 *)
const
  SCS_GAME_ID_EUT2 = SDKString('eut2');

{-------------------------------------------------------------------------------
  amtrucks/scssdk_telemetry_ats.pas
-------------------------------------------------------------------------------}

(**
 * @name Value used in the scs_sdk_init_params_t::game_version
 *
 * Changes in the major version indicate incompatible changes (e.g. changed interpretation
 * of the channel value). Change of major version is highly discouraged, creation of
 * alternative channel is preferred solution if necessary.
 * Changes in the minor version indicate compatible changes (e.g. added channel, more supported
 * value types). Removal of channel is also compatible change however it is recommended
 * to keep the channel with some default value.
 *
 * Changes:
 * 1.00 - initial version - corresponds to 1.12 in ETS2
 * 1.01 - added support for multiple trailers (doubles, triples), trailer ownership support,
 *        gameplay events support added
 * 1.02 - added planned_distance_km to active job info
 * 1.03 - added support for 'avoid_inspection', 'illegal_border_crossing' and 'hard_shoulder_violation' offence type in 'player.fined' gameplay event
 * 1.04 - added differential lock, lift axle and hazard warning channels
 * 1.05 - added multiplayer time offset and trailer body wear channel, fixed trailer chassis wear channel
 *)
//@{
const
  SCS_TELEMETRY_ATS_GAME_VERSION_1_00    = scs_u32_t((1 shl 16) or 0) {0x00010000};
  SCS_TELEMETRY_ATS_GAME_VERSION_1_01    = scs_u32_t((1 shl 16) or 1) {0x00010001};
  SCS_TELEMETRY_ATS_GAME_VERSION_1_02    = scs_u32_t((1 shl 16) or 2) {0x00010002}; // Patch 1.36
  SCS_TELEMETRY_ATS_GAME_VERSION_1_03    = scs_u32_t((1 shl 16) or 3) {0x00010003}; // Patch 1.36
  SCS_TELEMETRY_ATS_GAME_VERSION_1_04    = scs_u32_t((1 shl 16) or 4) {0x00010004}; // Patch 1.41
  SCS_TELEMETRY_ATS_GAME_VERSION_1_05    = scs_u32_t((1 shl 16) or 5) {0x00010005}; // Patch 1.45
  SCS_TELEMETRY_ATS_GAME_VERSION_CURRENT = SCS_TELEMETRY_ATS_GAME_VERSION_1_05;
//@}

// Game specific units.
//
// @li The game uses US Dolars as internal currency provided
//     by the telemetry unless documented otherwise.

// Channels defined in scssdk_telemetry_common_channels.h,
// scssdk_telemetry_job_common_channels.h,
// scssdk_telemetry_truck_common_channels.h and
// scssdk_telemetry_trailer_common_channels.h are supported
// with following exceptions and limitations as of v1.00:
//
// @li Adblue related channels are not supported.
// @li The fuel_average_consumption is currently mostly static and depends
//     on presence of the trailer and skills of the driver instead
//     of the workload of the engine.
// @li Rolling rotation of trailer wheels is determined from linear
//     movement.
// @li The pressures, temperatures and voltages are not simulated.
//     They are very loosely approximated.

// Configurations defined in scssdk_telemetry_common_configs.h are
// supported with following exceptions and limitations as of v1.00:
//
// @li The localized strings are not updated when different in-game
//     language is selected.

{-------------------------------------------------------------------------------
  amtrucks/scssdk_input_ats.pas
-------------------------------------------------------------------------------}

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

{-------------------------------------------------------------------------------
  amtrucks/scssdk_ats.pas
-------------------------------------------------------------------------------}

(**
 * @brief Value used in the scs_sdk_init_params_t::game_id to identify this game.
 *)
const
  SCS_GAME_ID_ATS = SDKString('ats');

implementation

uses
  SysUtils
{$IF not Defined(FPC) and (CompilerVersion >= 20)}(* Delphi2009+ *)
  , AnsiStrings
{$IFEND};

{-------------------------------------------------------------------------------
  scssdk.pas
-------------------------------------------------------------------------------}

{$IFDEF FPC}{$PUSH}{$WARN 5024 OFF}{$ENDIF} // supress warnings about unused parameters
Function scs_check_size(actual,expected_32,expected_64: TMemSize): Boolean;
begin
{$IF Defined(SCS_ARCHITECTURE_x64)}
  Result := actual = expected_64;
{$ELSEIF Defined(SCS_ARCHITECTURE_x86)}
  Result := actual = expected_32;
{$ELSE}
  {$MESSAGE FATAL 'Undefined architecture!'}  //better prevent compilation
  Halt; //architecture is not known, initiate immediate abnormal termination
{$IFEND}
end;
{$IFDEF FPC}{$POP}{$ENDIF}  // restore warning settings

//------------------------------------------------------------------------------

Function SCS_MAKE_VERSION(major, minor: scs_u16_t): scs_u32_t;
begin
Result := (major shl 16) or minor;
end;

//------------------------------------------------------------------------------

Function SCS_GET_MAJOR_VERSION(version: scs_u32_t): scs_u16_t;
begin
Result := (version shr 16) and $FFFF;
end;

//------------------------------------------------------------------------------

Function SCS_GET_MINOR_VERSION(version: scs_u32_t): scs_u16_t;
begin
Result := version and $FFFF;
end;

//------------------------------------------------------------------------------

Function SCS_VERSION_AS_STRING(version: scs_u32_t): String;
begin
Result := Format('%d.%d',[SCS_GET_MAJOR_VERSION(version),SCS_GET_MINOR_VERSION(version)]);
end;

//==============================================================================

Function APIString(const Str: SDKString): scs_string_t;
begin
Result := scs_string_t(PUTF8Char(Str));
end;

//------------------------------------------------------------------------------

Function APIStringToSDKString(const Str: scs_string_t): SDKString;
begin
If Assigned(Str) then
  begin
    SetLength(Result,{$IF Declared(AnsiStrings)}AnsiStrings.{$IFEND}StrLen(PAnsiChar(Str)));
    Move(Str^,PUTF8Char(Result)^,Length(Result) * SizeOf(UTF8Char));
  end
else Result := '';
end;

//------------------------------------------------------------------------------

Function SDKStringToAPIString(const Str: SDKString): scs_string_t;
begin
If Length(Str) > 0 then
  Result := scs_string_t({$IF Declared(AnsiStrings)}AnsiStrings.{$IFEND}StrNew(PAnsiChar(Str)))
else
  Result := nil;
end;

//------------------------------------------------------------------------------

procedure APIStringFree(var Str: scs_string_t);
begin
If Assigned(Str) then
  begin
    {$IF Declared(AnsiStrings)}AnsiStrings.{$IFEND}StrDispose(PAnsiChar(Str));
    Str := nil;
  end;
end;

//------------------------------------------------------------------------------

Function SDKStringDecode(const Str: SDKString): String;
begin
Result := StrRect.UTF8ToStr(Str);
end;

//------------------------------------------------------------------------------

Function SDKStringEncode(const Str: String): SDKString;
begin
Result := StrRect.StrToUTF8(Str);
end;

//==============================================================================

initialization
  //- scssdk.pas ---------------------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_sdk_init_params_v100_t),16,32));
  //- scssdk_value.pas ---------------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_value_bool_t),1,1));
  Assert(scs_check_size(SizeOf(scs_value_s32_t),4,4));
  Assert(scs_check_size(SizeOf(scs_value_u32_t),4,4));
  Assert(scs_check_size(SizeOf(scs_value_u64_t),8,8));
  Assert(scs_check_size(SizeOf(scs_value_s64_t),8,8));
  Assert(scs_check_size(SizeOf(scs_value_float_t),4,4));
  Assert(scs_check_size(SizeOf(scs_value_double_t),8,8));
  Assert(scs_check_size(SizeOf(scs_value_fvector_t),12,12));
  Assert(scs_check_size(SizeOf(scs_value_dvector_t),24,24));
  Assert(scs_check_size(SizeOf(scs_value_fplacement_t),24,24));
  Assert(scs_check_size(SizeOf(scs_value_dplacement_t),40,40));
  Assert(scs_check_size(SizeOf(scs_value_string_t),4,8));
  Assert(scs_check_size(SizeOf(scs_value_t),48,48));
  Assert(scs_check_size(SizeOf(scs_named_value_t),56,64));
  //- scssdk_telemetry_event.pas -----------------------------------------------
  Assert(scs_check_size(SizeOf(scs_telemetry_frame_start_t),32,32));
  Assert(scs_check_size(SizeOf(scs_telemetry_configuration_t),8,16));
  Assert(scs_check_size(SizeOf(scs_telemetry_gameplay_event_t),8,16));
  //- scssdk_telemetry.pas -----------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_telemetry_init_params_v100_t),32,64));
  //- scssdk_input_event.pas ---------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_input_event_t),28,28));
  //- scssdk_input_device.pas --------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_input_device_input_t),12,24));
  Assert(scs_check_size(SizeOf(scs_input_device_t),32,56));
  //- scssdk_input.pas ---------------------------------------------------------
  Assert(scs_check_size(SizeOf(scs_input_init_params_v100_t),20,40));

end.
