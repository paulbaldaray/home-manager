# Paul's MacOS Nix Config

## NIX SETUP

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

`nix run nix-darwin -- switch --flake ~/.config/home-manager`

## MANUAL TASKS

### Setup symlinks

```
for file in "kitty skhd yabai"; do
    ln -s ~/.config/home-manager/configs/$file ~/.config/$file
done
```

### Start Yabai and skhd

`yabai --start-service`
`skhd ---start-service`

### System settings > Accessibility > Display

* Reduce transparency: on
* Reduce motion: on

### Keyboard > Keyboard Shortcuts

* Turn everything off
* Mission control: desktop panels to OPTION + `number`
* Spotlight: search OPTION + `;`


### Github downloads

* nvim
* .shell
