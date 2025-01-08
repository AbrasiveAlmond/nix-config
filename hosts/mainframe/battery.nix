{
  options,
  config,
  lib,
  ...
}: {

  # Enable powertop
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  services = {
    # Enable thermald (only necessary if on Intel CPUs)
    thermald.enable = true;

    # Disable GNOMEs power management
    power-profiles-daemon.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "powersave";
          turbo = "auto";
        };
      };
    };
    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };

  # Better scheduling for CPU cycles - thanks System76!!!
  services.system76-scheduler.settings.cfsProfiles.enable = true;

  # Enable TLP (better than gnomes internal power manager)
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

     # Optional supposedly helps save long term battery health
     START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
}
