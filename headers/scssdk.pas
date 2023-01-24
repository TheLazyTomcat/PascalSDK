(**
 * @file scssdk.h
 *
 * @brief Common SDK types and structures.
 *)
unit scssdk;

{$INCLUDE scssdk_defs.inc}

interface

uses
  AuxTypes, StrRect;

{
  TelemetryString

  String type intended to hold strings for/from the API in a pascal-friendly
  way (that is, as managed, reference counted, copy-on-write string).
}
type
  TelemetryString = type UTF8String;

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
Function APIString(const Str: TelemetryString): scs_string_t; overload;{$IFDEF CanInline} inline;{$ENDIF}

{
  APIStringToTelemetryString

  Creates new variable of type TelemetryString, fills it with content of Str
  and then returns it.
  If the Str parameter is not assigned or is empty, then it will return an
  empty string;

  Use this function if you want to store strings returned from the API for
  later use.
}
Function APIStringToTelemetryString(const Str: scs_string_t): TelemetryString;

{
  TelemetryStringToAPIString

  Allocates new memory, fills it with content of Str and then returns pointer
  to it.

    WARNING - allocated memory must be explicitly freed using APIStringFree.

  If the Str is an empty string, then this function will return a nil (null)
  pointer.

  Use of this function is limited at this moment, it is here for the sake of
  completeness and a possible future use.
}
Function TelemetryStringToAPIString(const Str: TelemetryString): scs_string_t;

{
  TelemetryStringToAPIString

  Frees memory allocated by TelemetryStringToAPIString and sets the pointer to
  nil.
}
procedure APIStringFree(var Str: scs_string_t);

{
  TelemetryStringDecode

  Converts TelemetryString type to default string type.

  As default strings can be widly different depending on compiler, its version,
  used component library and other things, never do direct assignment between
  TelemetryString type and String type, always do the conversion.
}
Function TelemetryStringDecode(const Str: TelemetryString): String;{$IFDEF CanInline} inline;{$ENDIF}

{
  TelemetryStringEncode

  Converts default string type to TelemetryString type.
}
Function TelemetryStringEncode(const Str: String): TelemetryString;{$IFDEF CanInline} inline;{$ENDIF}

implementation

uses
  SysUtils;

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

Function APIString(const Str: TelemetryString): scs_string_t;
begin
Result := scs_string_t(PUTF8Char(Str));
end;

//------------------------------------------------------------------------------

Function APIStringToTelemetryString(const Str: scs_string_t): TelemetryString;
begin
If Assigned(Str) then
  begin
    SetLength(Result,StrLen(PAnsiChar(Str)));
    Move(Str^,PUTF8Char(Result)^,Length(Result) * SizeOf(UTF8Char));
  end
else Result := '';
end;

//------------------------------------------------------------------------------

Function TelemetryStringToAPIString(const Str: TelemetryString): scs_string_t;
begin
If Length(Str) > 0 then
  Result := scs_string_t(StrNew(PAnsiChar(Str)))
else
  Result := nil;
end;

//------------------------------------------------------------------------------

procedure APIStringFree(var Str: scs_string_t);
begin
If Assigned(Str) then
  begin
    StrDispose(PAnsiChar(Str));
    Str := nil;
  end;
end;

//------------------------------------------------------------------------------

Function TelemetryStringDecode(const Str: TelemetryString): String;
begin
Result := StrRect.UTF8ToStr(Str);
end;

//------------------------------------------------------------------------------

Function TelemetryStringEncode(const Str: String): TelemetryString;
begin
Result := StrRect.StrToUTF8(Str);
end;

//==============================================================================

{$IFDEF AssertTypeSize}
initialization
  Assert(scs_check_size(SizeOf(scs_sdk_init_params_v100_t),16,32));
{$ENDIF}

end.
