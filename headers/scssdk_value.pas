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
(*<unit>*)
(**
 * @file scssdk_value.h
 *
 * @brief Structures representing varying type values in the SDK.
 *)
unit scssdk_value;

{$INCLUDE scssdk_defs.inc}

interface

uses
  scssdk;

(*<interface>*)

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
   
(*</interface>*)

implementation

{$IFDEF AssertTypeSize}
initialization
(*<initialization>*)
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
(*</initialization>*)
{$ENDIF}

(*</unit>*)
end.
