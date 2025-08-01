@echo off

:: ------------------------------------------------------------
:: Tweaks for Windows 11
:: ------------------------------------------------------------

echo -- Enabling Classic Right-Click Menu...
reg import "scripts\enable-classic-right-click-menu.reg"

echo -- Adding End Task to Right-Click
reg import "scripts\enable-end-task-with-right-click.reg"

:: ------------------------------------------------------------
