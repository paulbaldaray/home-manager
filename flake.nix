{
  description = "Paul's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      users.users.paul = {
        name = "paul";
        home = "/Users/paul";
      };

      environment.systemPackages = [
         pkgs.vim
         pkgs.neovim
      ];

      # Homebrew stuff

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Allow apple touch id
      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        dock = {
          autohide = true;

          autohide-delay = 0.0;
          tilesize = 1;

          mru-spaces = false;
        };

        finder = {
          AppleShowAllExtensions = true;
          FXPreferredViewStyle = "clmv";
        };

        loginwindow.LoginwindowText = "Don't Steal My Data!";
        screencapture.location = "~/Pictures/screenshots";
        # screensaver.askForPasswordDelay = 1;
      };

      services.yabai.enable = true;
      services.yabai.config = {
        layout = "bsp";
        # focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        # window_placement    = "second_child";
        window_opacity      = "off";
        top_padding         = 10;
        bottom_padding      = 10;
        left_padding        = 10;
        right_padding       = 10;
        window_gap          = 10;
        mouse_modifier      = "alt";
      };
    };
    home = { pkgs, ... }: {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = "paul";
      home.homeDirectory = "/Users/paul";

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "23.11";

      home.packages = [
          pkgs.neovim
          pkgs.git
          pkgs.alacritty
          pkgs.neofetch
          pkgs.yabai
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."maclup" =
      nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.paul = home;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."maclup".pkgs;
  };
}
