let zoxide_cache = "/home/sorath/.cache/zoxide"
if not ($zoxide_cache | path exists) {
  mkdir $zoxide_cache
}
/nix/store/43vyy0hhvc5vfsb4qldr1jngjpgmr18q-zoxide-0.9.4/bin/zoxide init nushell  |
  save --force /home/sorath/.cache/zoxide/init.nu

let starship_cache = "/home/sorath/.cache/starship"
if not ($starship_cache | path exists) {
  mkdir $starship_cache
}
/etc/profiles/per-user/sorath/bin/starship init nu | save --force /home/sorath/.cache/starship/init.nu

let carapace_cache = "/home/sorath/.cache/carapace"
if not ($carapace_cache | path exists) {
  mkdir $carapace_cache
}
/nix/store/lbi7gc8wpmdsgqi4zrwifmz47y39sjmm-carapace-1.0.2/bin/carapace _carapace nushell | save -f $"($carapace_cache)/init.nu"

