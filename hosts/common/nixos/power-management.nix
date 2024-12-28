{
  # disable default gnome manual 3-choice performance management in favour of tlp
  services.power-profiles-daemon.enable = false;

  # Straight from the wiki
  # https://nixos.wiki/wiki/Laptop
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";


        # Change CPU energy/performance policy to power
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "default";

        # Enable the platform profile low-power:
        PLATFORM_PROFILE_ON_AC  = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # Disable turbo boost:
        CPU_BOOST_ON_AC  = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # auto – enabled (power down idle devices)
        RUNTIME_PM_ON_BAT = "auto";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
  };
  services.thermald.enable = true;
}