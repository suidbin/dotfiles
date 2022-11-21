# Idempotent - Script can run multiple times without issue
# Clean up unwanted desktop icons / shortcuts
$unwanted = @(
    "Microsoft Edge",
    "Steam"
)
$desktops = @(
    (New-Object -ComObject Shell.Application).NameSpace('shell:Desktop').Self.Path,
    (New-Object -ComObject Shell.Application).NameSpace('shell:Common Desktop').Self.Path
)
foreach($icon in $unwanted) {
    foreach($desktop in $desktops) {
        dir "${desktop}\$icon*.lnk" | Remove-Item
    }
}