{
  modulesPath,
  arch ? "x86_64-linux",
  ...
}:
{
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
    settings.PasswordAuthentication = true;
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
      experimental-features = "nix-command flakes pipe-operators";
    };
  };

  users.users.root = {
    password = "N1gg3rl1c10#s!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfHY4rNOm6DHH8XcmtU6CegX0/d99agN/x7MuPD5WJR sakhib@orzklv.uz"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAGqU+JleLM0T44P2quirtLPrhFExOi6EOe0GYXkTFcTSjhw9LqiuX1/FbqNdKTaP9k6CdV3xc/8Z5wxbNOhpcPi9XLoupv9oNyIew7QYl+ZoAck6/qPsM7uptGYCwo0/ErzPNLd3ERD3KT1axCqrI6rWJ+JFOMAPtGeAZZxIedksViZ5SuNhpzXCIzS2PACqDTxFj7JwXK/pQ200h9ZS0MSh7iLKggXQfRVDndJxRnVY69NmbRa4MqkjgyxqWSDbqrDAXuTHpqKJ5kpXJ6p2a82EIHcCwXXpEmLwKxatxWJWJb9nurm3aS74BYmT3pRVVSPC6n5a2LWN9GxzvVh3AXXZtWGvjXSqBxHdSyUoDPuZnDneycdRC5vs6I1jSGTyDFdc4Etq1M5uUYb6SqCjJIBvTNqVnOf8nzFwl/ENvc8sbIVtILgAbBdwDiiQSu8xppqWMZfkQJy+uI5Ok7TZ8o5rGIblzfKyTiljCQb7RO7Klg3TwysetREn8ZEykBx0= This world soon will cherish into my darkness of my madness"
    ];
  };

  # Networking (one time only)
  # Change whenever machines changes
  # networking.useDHCP = lib.mkForce true;
  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "45.150.26.120";
          prefixLength = 28;
        }
      ];
    };
    defaultGateway = {
      address = "45.150.26.117";
      interface = "ens18";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  nixpkgs.hostPlatform = arch;
}
