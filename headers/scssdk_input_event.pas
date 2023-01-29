(*<unit>*)
(**
 * @file scssdk_input_event.h
 *
 * @brief Input SDK - events.
 *)
unit scssdk_input_event;

{$INCLUDE scssdk_defs.inc}

interface

uses
  scssdk,
  scssdk_value;

(*<interface>*)

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

(*</interface>*)

implementation

{$IFDEF AssertTypeSize}
initialization
(*<initialization>*)
  Assert(scs_check_size(SizeOf(scs_input_event_t),28,28));
(*</initialization>*)
{$ENDIF}

(*</unit>*)
end.
