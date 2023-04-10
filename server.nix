{ system, pkgs, ... }:

{

  #system.stateVersion = "22.11";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  users.users.default.initialPassword = "password";
  users.users.default.isNormalUser = true;
  users.users.default.group = "default";
  users.users.default.extraGroups = [ "sudo" ];
  
  users.users.root.initialPassword = "password";

  environment.systemPackages = [
    pkgs.consul
    pkgs.apacheHttpd
  ];

  networking.useDHCP = true;

  services.consul = {
    enable = true;
    #datacenter = "dc1";
    #server = true;
    #bootstrap = true;
    webUi = true;
    interface.bind = "ens33";
    extraConfig = {
        retry_join = ["192.168.128.1"];
        enable_script_checks = true;
        enable_local_script_checks = true;
        service = {
          name = "web";
          port = 80;
          check = {
            name = "web-check";
            args = ["curl" "-L" "127.0.0.1"];
            interval = "5s";
            status = "passing";
          };
        };
    };
  };

  services.httpd.enable = true;
}