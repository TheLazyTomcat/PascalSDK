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
 * @file scssdk_telemetry_common_configs.h
 *
 * @brief Telemetry specific constants for configs.
 *
 * This file defines truck specific telemetry constants which
 * might be used by more than one SCS game. See game-specific
 * file to determine which constants are supported by specific
 * game.
 *)
unit scssdk_telemetry_common_configs;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

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
  
(*</interface>*)

implementation

(*</unit>*)
end.
