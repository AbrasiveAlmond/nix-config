{ config, lib, pkgs, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

    "org/gnome/shell" = {
      always-show-log-out = true;
      disable-user-extensions = false;

      favorite-apps = [
        "firefox.desktop"
        "spotify.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Calculator.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = 250;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      close = [ "<Super>c" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-group = [ "<Super>Tab" ];
      switch-group-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Alt><Super>space" ];
      switch-input-source-backward = [ "<Shift><Alt><Super>space" ];
      toggle-maximized = [ "<Super>m" ];
      unmaximize = [];
      maximize = [];
    };

    # Night light config
    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = [ "<Alt>y" ];
      play = [ "<Alt>k" ];
      previous = [ "<Alt>l" ];
      screensaver = [];
      volume-down = [ "<Alt>m" ];
      volume-up = [ "<Alt>j" ];
      www = [];
    };

    # Night light config
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-temperature = lib.hm.gvariant.mkUint32 3700;
      night-light-schedule-from = 18.0;
      night-light-schedule-to = 6.0;
    };

    # Overview folder configuration
    "org/gnome/desktop/app-folders" = {
      # folder-order-position = "start";
      folder-children = [
        "Utilities"
        "YaST"
        "Pardus"
        "1c0182f7-e89f-45c2-8fd2-713d1a64c732"
        "4888da92-fc61-4c96-a5b4-108c53be8a60"
        "c469386a-7bec-42a0-a056-1bd48e342cd7"
      ];
    };

    "org/gnome/desktop/app-folders/folders/1c0182f7-e89f-45c2-8fd2-713d1a64c732" = {
      apps = [
        "startcenter.desktop"
        "base.desktop"
        "calc.desktop"
        "draw.desktop"
        "impress.desktop"
        "math.desktop"
        "writer.desktop"
      ];
      name = "Office";
    };

    "org/gnome/desktop/app-folders/folders/4888da92-fc61-4c96-a5b4-108c53be8a60" = {
      apps = [
        "org.darktable.darktable.desktop"
        "gimp.desktop"
        "PTBatcherGUI.desktop"
        "calibrate_lens_gui.desktop"
        "hugin.desktop"
        "org.inkscape.Inkscape.desktop"
        "org.kde.krita.desktop"
      ];
      name = "Graphics";
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "org.gnome.FileRoller.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.Connections.desktop"
        "ca.desrt.dconf-editor.desktop"
        "ddcui.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.font-viewer.desktop"
        "org.gnome.Loupe.desktop"
        "org.gnome.Logs.desktop"
        "cups.desktop"
        "OpenTabletDriver.desktop"
        "org.gnome.Settings.desktop"
        "dev.vlinkz.NixSoftwareCenter.desktop"
        "gnome-system-monitor.desktop"
        "org.gnome.tweaks.desktop"
      ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/c469386a-7bec-42a0-a056-1bd48e342cd7" = {
      apps = [
        "io.elementary.code.desktop"
        "lapce.desktop"
        "nvim.desktop" 
        "org.gnome.TextEditor.desktop"
        "codium.desktop"
      ];
      name = "Code";
      translate = false;
    };
  };
}
# /org/gnome/desktop/app-folders/folders/bc163cad-310c-4642-8750-90ffd3fc24eb/apps
#   ['org.gnome.Characters.desktop', 'com.github.finefindus.eyedropper.desktop', 'org.gnome.font-viewer.desktop', 'de.haeckerfelix.Fragments.desktop', 'io.gitlab.adhami3310.Impression.desktop', 'io.gitlab.adhami3310.Converter.desktop', 'org.gnome.gitlab.YaLTeR.VideoTrimmer.desktop']

# /org/gnome/shell/app-picker-layout
#   [{'bc163cad-310c-4642-8750-90ffd3fc24eb': <{'position': <0>}>, 'c469386a-7bec-42a0-a056-1bd48e342cd7': <{'position': <1>}>, '4888da92-fc61-4c96-a5b4-108c53be8a60': <{'position': <2>}>, '1c0182f7-e89f-45c2-8fd2-713d1a64c732': <{'position': <3>}>, '8d6deb56-ac20-4fbf-9150-f7380cccf6f1': <{'position': <4>}>, 'Utilities': <{'position': <5>}>, 'io.bassi.Amberol.desktop': <{'position': <6>}>, 'org.gnome.clocks.desktop': <{'position': <7>}>, 'org.gnome.Connections.desktop': <{'position': <8>}>, 'org.gabmus.gfeeds.desktop': <{'position': <9>}>, 'org.gnome.Fractal.desktop': <{'position': <10>}>, 'org.gnome.Geary.desktop': <{'position': <11>}>, 'org.gnome.Maps.desktop': <{'position': <12>}>, 'com.github.alexhuntley.Plots.desktop': <{'position': <13>}>, 'org.gnome.World.Secrets.desktop': <{'position': <14>}>, 'org.gnome.Epiphany.desktop': <{'position': <15>}>}]