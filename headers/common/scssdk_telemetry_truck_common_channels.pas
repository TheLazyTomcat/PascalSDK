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
 * @file scssdk_telemetry_truck_common_channels.h
 *
 * @brief Truck telemetry specific constants for channels.
 *
 * This file defines truck specific telemetry constants which
 * might be used by more than one SCS game. See game-specific
 * file to determine which constants are supported by specific
 * game.
 *
 * Unless state otherwise, following rules apply.
 * @li Whenever channel has float based type (float, fvector, fplacement)
 *     is can also provide double based values (double, dvector, dplacement)
 *     and vice versa. Note that using the non-native type might incur
 *     conversion costs or cause precision loss (double->float in
 *     world-space context).
 * @li Whenever channel has u32 type is can also provide u64 value.
 *     Note that using the non-native type might incur conversion costs.
 * @li Whenever channel uses placement based type (dplacement, fplacement),
 *     it also supports euler type containg just the rotational part and
 *     dvector/fvector type containing just the positional part.
 * @li Indexed entries are using zero-based indices.
 *)
unit scssdk_telemetry_truck_common_channels;

{$INCLUDE '..\scssdk_defs.inc'}

interface

uses
  scssdk;
  
(*<interface>*)

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
  
(*</interface>*)

implementation

(*</unit>*)
end.
