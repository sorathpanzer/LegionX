let dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    bool: {|| if $in { 'light_cyan' } else { 'light_gray' } }
    int: white
    filesize: {|e|
      if $e == 0b {
        'white'
      } else if $e < 1mb {
        'cyan'
      } else { 'blue' }
    }
    duration: white
    date: {|| (date now) - $in |
      if $in < 1hr {
        'red3b'
      } else if $in < 6hr {
        'orange3'
      } else if $in < 1day {
        'yellow3b'
      } else if $in < 3day {
        'chartreuse2b'
      } else if $in < 1wk {
        'green3b'
      } else if $in < 6wk {
        'darkturquoise'
      } else if $in < 52wk {
        'deepskyblue3b'
      } else { 'dark_gray' }
    }    
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
}

$env.config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: true # always act as if -t was given. Can be overridden with -p
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    show_empty: true # show 'empty list' and 'empty record' placeholders for command output
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }
  show_banner: false
  color_config: $dark_theme
  footer_mode: auto
  use_grid_icons: true
  completions: {
  case_sensitive: false # case-sensitive completions
  quick: true    # set to false to prevent auto-selecting completions
  partial: true    # set to false to prevent partial filling of the prompt
  algorithm: "fuzzy"    # prefix or fuzzy
  external: {
  # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true 
  # set to lower can improve completion performance at the cost of omitting some options
      max_results: 100 
      # completer: $carapace_completer # check 'carapace_completer' 
    }
  }

menus: [
  # Configuration for default nushell menus
  # Note the lack of source parameter
  {
    name: abbr_menu
    only_buffer_difference: false
    marker: "👀 "
    type: {
      layout: columnar
      columns: 1
      col_width: 20
      col_padding: 2
    }
    style: {
      text: green
      selected_text: green_reverse
      description_text: yellow
    }
    source: { |buffer, position|
      scope aliases
      | where name == $buffer
      | each { |it| {value: $it.expansion }}
    }
  }
  {
    name: completion_menu
    only_buffer_difference: false
    marker: "| "
    type: {
        layout: columnar
        columns: 4
        col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2
    }
    style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
    }
  }
  {
    name: history_menu
    only_buffer_difference: true
    marker: "> "
    type: {
        layout: list
        page_size: 10
    }
    style: {
        text: red
        selected_text: white
        description_text: cyan
    }
  }
]

keybindings: [
  {
    name: abbr
    modifier: control
    keycode: space
    mode: [emacs, vi_normal, vi_insert]
    event: [
    { send: menu name: abbr_menu }
    { edit: insertchar, value: ' '}
    ]
  }
  {
    name: completion_menu
    modifier: none
    keycode: tab
    mode: [emacs vi_normal vi_insert]
    event: {
      until: [
        { send: menu name: completion_menu }
        { edit: complete }
      ]
    }
  }
  {
    name: history_menu
    modifier: control
    keycode: char_r
    mode: vi_normal
    event: { send: menu name: history_menu }
  }
  {
    name: yank
    modifier: control
    keycode: char_y
    mode: vi_normal
    event: {
      until: [
        {edit: pastecutbufferafter}
      ]
    }
  }
  {
    name: unix-line-discard
    modifier: control
    keycode: char_z
    mode: [emacs, vi_normal, vi_insert]
    event: {
      until: [
        {edit: cutfromlinestart}
      ]
    }
  }
]

} 
 $env.PATH = ($env.PATH | split row (char esep)
   #| prepend /home/sorath/.local/bin
   | append /home/sorath/.local/bin
   | append /home/sorath/.local/bin/apps
   | append /home/sorath/.local/bin/helix
   | append /home/sorath/.local/bin/hyprland
   | append /home/sorath/.cargo/bin
)

$env.EDITOR = "/nix/store/h0cn28h7mvkj1vwbdj4zkzkailkwr1i0-helix-24.03/bin/hx"
$env.BROWSER = "/nix/store/lx4ld5j3n23v835y1ycg1hd30j31pb9n-librewolf-131.0.2-1/bin/librewolf"
$env.TERMINAL = "/nix/store/3861xns0bxs2z2slxk2kfffl52h98pmf-foot-1.17.2/bin/kitty"
$env.READER = "/nix/store/xha3fz4fl6yk0bdiqmch2q3jxv5s93lf-zathura-with-plugins-0.5.5/bin/zathura"

$env.XDG_CONFIG_HOME = "/home/sorath/.config"
$env.XDG_DATA_HOME = "/home/sorath/.local/share"
$env.XDG_CACHE_HOME = "/home/sorath/.cache"

$env.PASSWORD_STORE_ENABLE_EXTENSIONS = "true"
$env.PASSWORD_STORE_EXTENSIONS_DIR = "/home/sorath/.config/Pass/"

$env.GTK_THEME = "Sweet-nova:dark"
$env._JAVA_AWT_WM_NONREPARENTING = 1

def tg [] { cd /home/sorath/.config/LegionX | /nix/store/46jna9h25khan7lj0yg5s31ik2rbpfdd-gitui-0.26.3/bin/gitui }

def mp3 [] {
  yt-dlp -x --audio-format mp3 (/nix/store/spba9cni8gy3sc1hgd53iwkgi0vki9zs-wl-clipboard-2.2.1/bin/wl-paste)
}

def mp4 [] {
  yt-dlp (/nix/store/spba9cni8gy3sc1hgd53iwkgi0vki9zs-wl-clipboard-2.2.1/bin/wl-paste)
}

def l [] {
  ls | sort-by type name -i
}

def fwupd [] {
  sudo /nix/store/4l5m53bigcd02r3s0jv4ixd95fawwslg-fwupd-1.9.19/bin/fwupdmgr refresh --force
  sudo /nix/store/4l5m53bigcd02r3s0jv4ixd95fawwslg-fwupd-1.9.19/bin/fwupdmgr get-updates
  sudo /nix/store/4l5m53bigcd02r3s0jv4ixd95fawwslg-fwupd-1.9.19/bin/fwupdmgr update
}

def ghs [$args: string] {
  ormolu --mode inplace $args
  ghc -Wall -Werror -no-keep-hi-files -no-keep-o-files $args
}


source /home/sorath/.cache/zoxide/init.nu

def --env ya [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

use /home/sorath/.cache/starship/init.nu

source /home/sorath/.cache/carapace/init.nu

alias apg = apg -a 1 -n1 -m
alias calc = qalc
alias check = /nix/store/rir8xiivx1c3p3va606hfnh7zdaacm9i-shellcheck-0.10.0-bin/bin/shellcheck --shell=bash --exclude=SC2086,SC2016,SC1091
alias diff = delta
alias dua = /nix/store/2i4miivwby2cfcc91a18swxp3i86bc03-dua-2.29.0/bin/dua i
alias fzf = /nix/store/aflkybxcxzm4fxnan2fg9z4d8dyd4qnb-fzf-0.52.1/bin/fzf -m
alias gparted = sudo -e gparted
alias grep = grep -i
alias gt = /nix/store/46jna9h25khan7lj0yg5s31ik2rbpfdd-gitui-0.26.3/bin/gitui
alias hm = hx /home/sorath/.config/LegionX/profiles/home.nix
alias nx = /nix/store/zdz6vzi4fgrvbpp2sp7xay95pb9jik82-nvd-0.2.3/bin/nvd diff ...(ls /nix/var/nix/profiles/system-*-link | get name | drop 1 | last 1) /run/current-system
alias qr = qrencode -s 6 -l H -o "text.png"
alias xpg = gpg -c --no-symkey-cache --cipher-algo AES256