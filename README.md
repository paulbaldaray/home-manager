# Paul's MacOS Nix Config

## NIX SETUP

### Rosetta

`softwareupdate --install-rosetta --agree-to-license`

### Download Nix

```
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install
```

### Run Nix Darwin

nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin --extra-experimental-features nix-command -- switch --flake ~/.config/home-manager

## Rebuild

darwin-rebuild switch --flake .

## MANUAL TASKS

### Setup symlinks

```
for file in kitty skhd yabai; do
    ln -s ~/.config/home-manager/configs/$file ~/.config/$file
done
```

### Start Yabai and skhd

`yabai --start-service`
`skhd ---start-service`

### System settings > Accessibility > Display

* Reduce transparency: on
* Reduce motion: on

### Keyboard > Keyboard layouts

* Disable everything

### Keyboard > Keyboard Shortcuts

* Turn everything off
* Mission control: desktop panels to OPTION + `number`
* Spotlight: search OPTION + `;`


### Github downloads

* nvim
* .shell

### Commands

* defaults write -g ApplePressAndHoldEnabled -bool false
