#!/usr/bin/bash

EXPORT_PATH="/home/igor/Documents/space_invaders_build/"
godots() {
    flatpak run io.github.MakovWait.Godots "$@"
}
    
godots exec --name "Godot v4.7.2 stable" --headless -- -q --headless --export-debug "Windows Desktop" "$EXPORT_PATH"
