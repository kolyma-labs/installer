{
  modulesPath,
  arch ? "x86_64-linux",
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  services.openssh = {
    enable = true;
    ports = [
      22
      2222
      22222
    ];
    extraConfig = ''
      PrintLastLog no
    '';
    settings.PasswordAuthentication = false;
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Disable if you don't want linux thingies on mac
      allowUnsupportedSystem = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # Let the system use fucked up programs
      allowBroken = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
    };
  };

  users.users.root = {
    password = "N1gg3rl1c10#s!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfHY4rNOm6DHH8XcmtU6CegX0/d99agN/x7MuPD5WJR sakhib@orzklv.uz"
    ];
  };

  # Networking (one time only)
  # Change whenever machines changes
  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "45.150.26.18";
          prefixLength = 28;
        }
      ];
    };
    defaultGateway = {
      address = "45.150.26.17";
      interface = "ens18";
    };

    nameservers = [
      "8.8.8.8"
    ];
  };

  nixpkgs.hostPlatform = arch;
}
