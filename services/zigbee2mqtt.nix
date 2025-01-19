{
  virtualisation.oci-containers.containers."zigbee2mqtt" = {
    image = "koenkk/zigbee2mqtt:1.42.0";
    autoStart = true;
    volumes = [
      "/mnt/lethe/zigbee2mqtt/data:/app/data"
      "/run/udev:/run/udev:ro"
    ];
    environment = {
      TZ = "Europe/London";
    };
    ports = [
      "8099:8099/tcp"
    ];
    extraOptions = [
      "--pull=always" 
      "--device=/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20230505110350-if00:/dev/ttyACM0"
    ];
  };
}
