# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "ktec"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #Enable the Budgie Desktop Environment
  #services.desktopManager.budgie.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    /* ── Input devices ────────────────────────────────── */
#  services.libinput.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
 #  services.xserver.libinput.enable = true;

  # ─────────────────────────────────────────────────────────
  # NIX SETTINGS
  # ─────────────────────────────────────────────────────────

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

   #enabling nix search
   nix.settings.experimental-features = [ "nix-command" "flakes" ];   

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ktec" = {
    isNormalUser = true;
    description = "ktec";
    extraGroups = [
      "networkmanager" "wheel"
      "docker" "podman"
      "wireshark"
      "video"
      "audio"
      "libvirtd"
      "kvm"
      ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # ─────────────────────────────────────────────────────────
  # BASH + STARSHIP
  # ─────────────────────────────────────────────────────────

 /* programs.bash = {
    enable = true;
    interactiveShellInit = ''
      # ── Starship Prompt ──────────────────────────────────
      eval "$(${pkgs.starship}/bin/starship init bash)"

     # ── FZF (fuzzy finder + completion) ──────────────────
      eval "$(${pkgs.fzf}/bin/fzf --bash)"

        # ── FZF (if installed) ───────────────────────────────
      if command -v fzf &> /dev/null; then
        source <(fzf --bash)
      fi

      # ── Bash Completion ──────────────────────────────────
      [ -r /etc/bash_completion ] && source /etc/bash_completion

      # ── History ──────────────────────────────────────────
      HISTSIZE=10000
      HISTFILESIZE=20000
      HISTCONTROL=ignoredups:erasedups
      HISTTIMEFORMAT="%F %T "
      shopt -s histappend
      shopt -s checkwinsize

      # ── Auto-completion on TAB ──────────────────────────
      bind 'set completion-ignore-case on'
      bind 'set show-all-if-ambiguous on'
      bind '"\C-n": history-search-forward'
      bind '"\C-p": history-search-backward'


      # ── Aliases ──────────────────────────────────────────
      alias ls='${pkgs.eza}/bin/eza --icons'
      alias ll='${pkgs.eza}/bin/eza --icons -la'
      alias cat='${pkgs.bat}/bin/bat'
      alias grep='${pkgs.ripgrep}/bin/rg'
      alias find='${pkgs.fd}/bin/fd'

      # System
      alias update='sudo nixos-rebuild switch'
      alias cleanup='nix-collect-garbage -d'
      alias listgens='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'

      # Git
      alias gs='git status'
      alias gc='git commit -m'
      alias gp='git push'
      alias gl='git log --oneline --graph'

      # Development
      alias py='python3'
      alias d='podman'
      alias dc='podman-compose'
    '';
  };  */

  # ─────────────────────────────────────────────────────────
# ZSH + OH-MY-ZSH (minimal, working)
# ─────────────────────────────────────────────────────────

programs.zsh = {
  enable = true;
  enableBashCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;

  ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "docker"
      "sudo"
      "history"
      "fzf"
    ];
    #theme = "robbyrussell";  # Simple default theme (not p10k yet)
    #theme = "powerlevel10k";
    theme = "agnoster";  /* Simple, clean theme */
  };


  #interactiveShellInit = ''
    /* P10k instant prompt */
    #if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
     # source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    #fi

    /* Source p10k config if it exists */
    #[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  interactiveShellInit = ''

    # Aliases
    alias ls='${pkgs.eza}/bin/eza --icons'
    alias ll='${pkgs.eza}/bin/eza --icons -la'
    alias cat='${pkgs.bat}/bin/bat'
    alias grep='${pkgs.ripgrep}/bin/rg'

    # System
    alias update='sudo nixos-rebuild switch'
    alias cleanup='nix-collect-garbage -d'

    # Git
    alias gs='git status'
    alias gc='git commit -m'
    alias gp='git push'
  '';
};

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #-----Flatpak ------
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   pkgs.git
   #pkgs.neovim
   pkgs.curl
   pkgs.fastfetch
   pkgs.htop
   pkgs.wget
   pkgs.zsh
   pkgs.oh-my-zsh
   pkgs.zsh-powerlevel10k
   pkgs.zsh-syntax-highlighting
   pkgs.nix-search-cli
   #pkgs.shellcheck

   btop
   fzf ripgrep fd
   bat eza zoxide
   jq yq
   tree rsync
   strace lsof
   unzip zip
   figlet direnv
   smartmontools ncdu
   shellcheck
   vim nano
   cava peaclock pipes-rs cmatrix gtop starship cheese  
  #bitwarden-desktop

   # ── Development Tools ────────────────────────────────
    # C/C++ build tools
   gcc clang  cmake gnumake
   pkg-config autoconf automake llvm libtool
    #Node
   nodejs
    #Rust
   rustup cargo
   #Go
   go
    #Python
   python3 
   python3.pkgs.pip 
   python3.pkgs.virtualenv
   python3.pkgs.numpy 
   python3.pkgs.pandas 
   python3.pkgs.matplotlib
   python3.pkgs.requests 
   python3.pkgs.beautifulsoup4
   python3.pkgs.flask 
   python3.pkgs.django 
   python3.pkgs.fastapi
   python3.pkgs.sqlalchemy 
   python3.pkgs.psycopg2
   #Java
   openjdk21
   #Lua
   lua
   #php
   php
  # Build essentials
    binutils gdb valgrind
    ninja meson

   # ── Neovim ──────────────────────────────────────────
   neovim
   wakatime-cli
   live-server
   browsh
   #nixd  # Nix LSP
   #lua-language-server
   #nodePackages.pyright
   #nodePackages.typescript-language-server
   #nodePackages.vscode-langservers-extracted
   #clang-tools
   #shellcheck

   # ── Terminals & Fonts ────────────────────────────────
   kitty
   alacritty
   wezterm
   foot
   ghostty
   powerline-fonts
   nerd-fonts.fira-code
   nerd-fonts.jetbrains-mono

    # ── Wayland & Display ────────────────────────────────
    wayland
    wayland-protocols
    libxkbcommon
    libinput
    xwayland
    dunst
    wofi
    swww
    wl-clipboard
    #wl-paste
    xclip
    xsel

    #-------NIRI-------------
    niri
    swaylock
    swayidle
    brightnessctl

   /* ── Hyprland Core ────────────────────────────────── */
    hyprland
    hyprlock
    hypridle
    hyprpicker

   /* ── Bar & Launcher ───────────────────────────────── */
    waybar
    wofi
    swww

    /* ── Notifications ────────────────────────────────── */
    dunst
    libnotify
    mako
    /* ── Screenshots & Screen Recording ───────────────── */
    grim
    slurp
    wf-recorder

    /* ── Color Picker ────────────────────────────────── */
    hyprpicker

    /* ── Lockscreen ────────────────────────────────────– */
    hyprlock

    /* ── Polkit (for sudo prompts) ────────────────────– */
    polkit_gnome

    /* ── Fonts for UI ────────────────────────────────– */
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

   # ── Media ────────────────────────────────────────────
    ffmpeg
    imagemagick
    mpv
    pulseaudio
    pavucontrol
    alsa-utils
    vlc
    spotify

    #-------Browsers------------
    brave
    tor-browser
    google-chrome
    chromium
    librewolf
    microsoft-edge

    #__________Socials__________
    telegram-desktop
    signal-desktop
    slack
    zoom-us
    discord
    #teams
    whatsie
    tutanota-desktop #mailing
    smile  #emojis

    #-----documentation-------
    libreoffice
    onlyoffice-desktopeditors
    cherrytree
    obsidian
    sleek-todo

      
     # ── CYBERSECURITY & PENETRATION TESTING ──────────────

    # Network reconnaissance
    nmap
    masscan
    netcat
    socat

    # Web security & testing
    wireshark
    burpsuite
    sqlmap
    nikto

    # Password & hash cracking
    hashcat
    hydra
    john
    aircrack-ng

    # Vulnerability scanning
    openvas-scanner
    #nessus

    # Traffic analysis & sniffing
    tcpdump
    tshark
    mitmproxy

    # Reverse engineering & debugging
    ghidra
    radare2
    gdb
    strace
    ltrace
    cutter #
    #objdump

    # Exploitation & payload generation
    metasploit

    # Cryptography & encoding
    openssl
    gnupg
    xxd
    hexdump

    # Port scanning & enumeration
    nmap
    zmap

    # DNS enumeration
    #dnsrecon
    dnsenum
    dig
    host

    # Directory brute forcing
    gobuster
    dirbuster
    wfuzz

    # Subdomain enumeration
    amass

    # SSL/TLS testing
    sslscan
    testssl

    # Fuzzing
    radamsa

    # Binary analysis
    binwalk
    file
    

    # Wireless security
    aircrack-ng
    wireshark

    # Malware analysis
    yara

    # Code analysis
    checksec

    # API testing
    curl
    httpie
    insomnia
     postman  # If available

    # Other useful tools
    ntp
    mtr
    iperf
    speedtest-cli
    whois
    traceroute
    arp-scan


   # ── Databases ────────────────────────────────────────
    sqlite
    postgresql
    redis
    #mongodb
    dbeaver-bin
    # ── Data Processing ─────────────────────────────────
    duckdb

    # ── Container Tools ─────────────────────────────────
    podman
    podman-compose
    containerd
    docker
    distrobox

    # ── Archives & Compression ─────────────────────────
    #tar
    gzip
    bzip2
    xz
    p7zip
    rar
    unrar

    # ── Utilities ────────────────────────────────────────
    tldr
    man-pages
    man-pages-posix
    fzf
    ripgrep
    fd
    parallel
    watch

  #________AI TOOLS______________
    ollama
    gemini-cli
    codex
    github-copilot-cli
    gemini-cli-bin
    antigravity
    
 #------Code Editors--------
    vscode
    zed-editor

 #____---DRIVEs EDITORS------
 #ventoy
 gparted

  #________Bluetooth Tools_________
    bluez
    bluez-tools
   # bluedevil

 #-------BUDGIE DESKTOP--------------
 /* budgie-desktop-with-plugins
  budgie-control-center
  budgie-backgrounds
  budgie-session */
  


  ];




  # ─────────────────────────────────────────────────────────
  # SSH SERVER
  # ─────────────────────────────────────────────────────────

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
    };
    ports = [ 22 ];
  };
  
networking.firewall.enable = true;
networking.firewall.allowedTCPPorts = [ 
  22 80 443           # SSH, HTTP, HTTPS
  3000 3001           # Node/Rails
  5000 5001 5500      # Flask, .NET
  4000                # GraphQL
  8000 8001 8080 8081 # Django, Java, Go, PHP
  5173 5174 5175      # Vite (frontend)
  5432                # PostgreSQL
  3306                # MySQL
  27017               # MongoDB
  6379                # Redis
];

# ─────────────────────────────────────────────────────────
  # WIRESHARK PERMISSIONS
  # ─────────────────────────────────────────────────────────

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

#____________DMS-HYPRLAND____________________________
#  programs.dms-shell.enable = true;
# ─────────────────────────────────────────────────────────
  # DANK MATERIAL SHELL (DMS)
  # ─────────────────────────────────────────────────────────

 /* programs.dms-shell = {
    enable = true;

    systemd = {
      enable = false;
      restartIfChanged = true;
    }; */

    /* Feature toggles */
   /* enableSystemMonitoring = true;     # System stats widget
    enableVPN = true;                  # VPN management
    enableDynamicTheming = true;       # Wallpaper-based colors
    enableAudioWavelength = true;      # Audio visualizer
    enableCalendarEvents = true;       # Calendar integration
    enableClipboardPaste = true;       # Clipboard history

    quickshell.package = pkgs.quickshell; # or your custom package

  }; */
   

   
  # ─────────────────────────────────────────────────────────
  # HYPRLAND + WAYLAND + DEPENDENCIES
  # ─────────────────────────────────────────────────────────

 # services.xserver.enable = true;
/*services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  }; */ 

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

#-----------BLUETOOTH--------------------
   hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;  # Auto-enable on startup
  };

  services.blueman.enable = true;  # Bluetooth manager GUI


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
