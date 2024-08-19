{
  # Enable CUPS to print documents.
    # Most printers manufactured after 2013 support
    # the IPP Everywhere protocol, i.e. printing without
    # installing drivers. This is notably the case of
    # all WiFi printers marketed as Apple-compatible.
    # (which ours is)
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      # nssmdns4 = true;
      openFirewall = true;
    };
}