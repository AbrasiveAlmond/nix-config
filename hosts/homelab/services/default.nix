{ config, lib, ... }:

{
  imports = [ ./immitch.nix ];

  users.groups.immitch = {};
}
