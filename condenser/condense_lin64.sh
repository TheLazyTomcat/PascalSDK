cd ../headers
"../condenser/condenser_lin64"\
  --split\
  -d "./scssdk_defs.inc"\
  -c "./scssdk.pas"\
  -t "../condenser/out_template.txt"\
  -o "../headers_condensed/PascalSDK.pas"\
  -s "./scssdk.pas",\
     "./scssdk_value.pas",\
     "./scssdk_telemetry_event.pas",\
     "./scssdk_telemetry_channel.pas",\
     "./scssdk_telemetry.pas",\
     "./scssdk_input_event.pas",\
     "./scssdk_input_device.pas",\
     "./scssdk_input.pas",\
     "./common/scssdk_telemetry_common_configs.pas",\
     "./common/scssdk_telemetry_common_gameplay_events.pas",\
     "./common/scssdk_telemetry_common_channels.pas",\
     "./common/scssdk_telemetry_truck_common_channels.pas",\
     "./common/scssdk_telemetry_trailer_common_channels.pas",\
     "./common/scssdk_telemetry_job_common_channels.pas",\
     "./eurotrucks2/scssdk_telemetry_eut2.pas",\
     "./eurotrucks2/scssdk_input_eut2.pas",\
     "./eurotrucks2/scssdk_eut2.pas",\
     "./amtrucks/scssdk_telemetry_ats.pas",\
     "./amtrucks/scssdk_input_ats.pas",\
     "./amtrucks/scssdk_ats.pas"