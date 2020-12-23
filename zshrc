[[ $- != *i* ]] && return
##Pre stuff
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi
stty -ixon
[[ -f /etc/updates.txt ]] && { head -n1 /etc/updates.txt; echo; }
##Prompt
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

#zstyle ':vcs_info:*' enable git cvs svn

vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}


user=chad
if [[ -n $DISPLAY ]] && (( EUID == $(id -u $user) )); then
    PROMPT="%(?,Ω,ω) %~/ "
    if [[ -n "$DESKTOP_SESSION" ]]; then
        eval $(gnome-keyring-daemon --start)
        export SSH_AUTH_SOCK
    fi
else
    PROMPT="[%B%(?,%F{blue},%F{red})%n%f%b@%m %B%40<..<%~%<< %b] %# "
fi

#RPROMPT="%B%(?..%?)%b"
RPROMPT=$'$(vcs_info_wrapper)'



pgrep mpd &>/dev/null || mpd &>/dev/null
#Make sure mux is running
[[ $commands[tmux] ]] && [[ -z "$TMUX" ]] && exec tmux
##ZSH options
autoload -U compinit promptinit colors && colors
setopt completealiases auto_cd append_history share_history histignorealldups histignorespace extended_glob longlistjobs nonomatch notify hash_list_all completeinword nohup auto_pushd pushd_ignore_dups nobeep noglobdots noshwordsplit nohashdirs inc_append_history prompt_subst
promptinit
compinit -i
export REPORTTIME=5 TIMEFMT="%J  %U user %S system %P cpu %*E total  %MMb mem"
watch=(notme root)
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export PATH="$HOME/.cabal/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:$HOME/bin:/usr/bin/core_perl:/usr/local/scripts:$HOME/.local/bin"

if [[ ! -L /bin ]]; then
    export PATH="/bin:/sbin:$PATH"
fi


if type nvim &> /dev/null; then
    export EDITOR="nvim"
    alias vim=nvim
    alias vi=nvim
elif type vim &> /dev/null; then
    export EDITOR="vim"
    alias vi=vim
else 
    export EDITOR="vi"
    alias vim=vi
fi

[[ $commands[neomutt] ]] && alias mutt=neomutt

type firefox &> /dev/null && export BROWSER="firefox"
type firefox-developer-edition &> /dev/null && export BROWSER="firefox-developer-edition"


##Completion optios
# Most are stolen from grml-zsh-config
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true
# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false
zstyle ':completion:*:history-words'   menu yes
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes
# match uppercase from lowercase
zstyle ':completion:*'                  matcher-list '' \
                                        'm:{a-z\-}={A-Z\_}' \
                                        'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
                                        'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'
zstyle ':completion:*:options'         description 'yes'
# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# provide verbose completion information
zstyle ':completion:*'                 verbose true
zstyle ':completion:*:-command-:*:'    verbose false
# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'
# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select
# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin 
# provide .. as a completion
zstyle ':completion:*' special-dirs ..
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
zstyle ':completion:*' menu select



##Aliases
ips(){echo -e "LAN IP: $(ip route get 8.8.8.8 | awk -F'src ' '!/cache/{print $2}')\nWAN IP: $(curl -s ipv4.icanhazip.com)"}
alias wftop='sudo iftop -i wlp3s0'
alias c='clear'
alias vimrc='vim /home/chad/.vimrc'
alias chkupd='checkupdates'
alias m="mpd ~/.config/mpd/mpd.conf"
alias snp='sudo snp'
alias mstat='dstat -tcmnd --top-cpu --top-mem'
alias nfs='mount ~/Cloud/nfs'
alias dc='cd'
alias z='source ~/.zshrc'
alias pg='ps -ef | grep --color'
alias svim='sudoedit'
alias ivm='vim'
alias e='exit'
alias q='exit'
alias ZZ='exit'
alias addto='todo.sh a $(date "+%Y-%m-%d)'
alias todo='todo.sh'
alias treset='sudo modprobe -r psmouse; sudo modprobe psmouse'
alias info='info --vi-keys'
alias -g pacupg-dev='~/bin/pacupg/pacupg'
alias ytau='youtube-dl --extract-audio --audio-format'
alias perfgraph='perf record --call-graph dwarf -e cycles:u'

nport(){nmap -p $1 --open -sV "$(echo "$(ip route get 8.8.8.8 | awk -F'src ' '!/cache/{print $2}' | tr -d ' ')/$2")"}

alias snapnum='echo $(($(snapper list | wc -l)-3))'

for i in fuck damnit please; do
    alias $i='source ~/.zshrc;fc -ln -1; sudo -E $(fc -ln -1)'
done

if type pycodestyle &> /dev/null; then
    alias pep8="pycodestyle"
fi

rman(){
    for ((i=0 ; i < 5 ; i++)); do 
        cmd=$(command ls -1 /usr/bin | sort -R | head -n1);
        if [[ "$(man -k "$cmd" |& awk -F': ' '{print $2}')" != "nothing appropriate." ]] &> /dev/null; then
            man "$cmd"
            return 0
        fi
    done 
    >&2 echo "Five failed attempts at finding a suitable command. Aborting."
    return 1
}

#rev(){ echo "r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"}

open(){
    if (($# > 0)); then 
        for arg in $@; do
            if [[ -e "$arg" ]]; then
                xdg-open "$arg" &> /dev/null
            else
                echo "Argument '$arg' does not exist"
            fi
        done
    else
        echo "At least one argument required"
        return 1
    fi
}

fix-steam() {
   find ~/.local/share/Steam/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" -o -name "libgpg-error.so*" \) -print -delete 
   find ~/.steam/root/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" -o -name "libgpg-error.so*" \) -print -delete
}

up() {
    local dest=".." 
    local limit=${1:-1} 

    for ((i=2 ; i <= limit ; i++)); do 
         dest=$dest/..
    done 

    if [[ -t 1 ]]; then
        cd "$dest"
    elif type realpath &> /dev/null; then
        # Resolve path if we can
        realpath "$dest"
    else
        # Print relative if we can't
        echo "$dest"
    fi
} 
export TERM=screen-256color
export CC=gcc
export CFLAGS='-Wall -O0 -ggdb3 -Wextra -std=gnu11'
export CXX='g++'
export CXXFLAGS='-Wall -O0 -ggdb3 -Wextra -std=gnu++17'

for i in mv cp; do
    type a${i} && alias $i="a${i} -g"
done &> /dev/null

command grep '^DISTRIB_ID=' /etc/lsb-release | source /dev/stdin
distro=$(echo $DISTRIB_ID | awk '{print tolower($0)}')
unset DISTRIB_ID
case "$distro" in 
    arch|antergos) 
        pacin(){sudo pacman -S $@; pkgdump}
        pacins(){sudo pacman -U $@; pkgdump}
        pacre(){sudo pacman -R $@; pkgdump}
        pacrem(){sudo pacman -Rns $@; pkgdump}
        pacremc(){sudo pacman -Rnsc $@; pkgdump}
        aurin(){trizen -S $@;  pkgdump}
        aurre(){trizen -R $@; pkgdump}
        aurrem(){trizen -Rns $@; pkgdump}
        aurremc(){trizen -Rnsc $@; pkgdump}
        
        alias pacdown='sudo pacman -Sw'
        alias pacupd="sudo pacman -Sy && sudo abs"
        alias pacinsd='sudo pacman -S --asdeps'
        alias paclf='pacman -Ql'
        alias pacrep='pacman -Si'
        alias pacreps='pacman -Ss'
        alias pacloc='pacman -Qi'
        alias paclocs='pacman -Qs'
        alias pacmir='sudo pacman -Syy'
        alias paclo='pacman -Qdt'
        alias pacro='sudo pacman -Rs $(pacman -Qtdq)'
        alias pacunlock="sudo rm /var/lib/pacman/db.lck"
        alias paclock="sudo touch /var/lib/pacman/db.lck"
        type pacupg &> /dev/null || alias pacupg="sudo pacman -Syu"
        alias pacupga='pacupg -a; sudo abs'
        alias pacc='sudo pacman -Sc'
        alias paccc='sudo pacman -Scc'
        alias pacdown='sudo pacman -Sw'
        alias pacfile='pacman -Ql'
        
        alias yaconf='yaourt -C'
        alias aursu='trizen -Syu --noconfirm'
        alias aurrep='trizen -Si'
        alias aurreps='trizen -Ss'
        alias aurloc='trizen -Qi'
        alias aurlocs='trizen -Qs'
        alias aurlst='trizen -Qe'
        alias aurorph='trizen -Qtd'
        alias aurupga='pacupg -a && sudo abs'
        alias aurmir='trizen -Syy'
        alias aurmake='trizen -Sw'
        alias aurcheck='trizen -k'
        alias aurclean='trizen -cc'
        export ABSROOT="/home/chad/.abs"
        ;;
    gentoo)
        alias emin='sudo emerge --ask --autounmask-write'
        alias emre='sudo emerge -C'
        alias emrem='sudo emerge -cav'
        alias emclean='sudo emerge -av --depclean'
        alias emsearch='emerge --search'
        alias emdesc='sudo emerge --descsearch'
        alias emsyn='sudo emerge --sync'
        alias emupg="sudo emerge --sync && sudo emerge -uNDav @world && sudo revdep-rebuild"
        alias empret='sudo emerge --pretend' 
        efiles(){sudo equery files $1 | less}
        alias emrebuild=' sudo emerge --update --deep --newuse @world'
        alias confs='sudo dispatch-conf'
        alias euse='sudo euse'
        alias es='sudo eselect'
        alias esl='eselect list'
        ;;
    ubuntu|debian)
        alias aptin='sudo apt-get install'
        alias aptins='dpkg -i'
        alias aptre='sudo apt-get remove'
        aptrem(){sudo apt-get purge "$@" && sudo apt-get autoremove}
        alias aptupd='sudo apt-get update'
        alias aptupg='sudo apt-get updgrade'
        alias aptdupg='sudo apt-get dist-upgrade'
        alias aptfupg='sudo apt-get update && sudo apt-get dist-upgrade'
        alias aptrep='apt-cache show'
        alias aptreps='apt-cache search'
        aptlocs(){dpkg -l "*${1}*" | for i in "$@"; do shift; (( $# > 0 )) && command grep  -i "$1" || break; done}
        alias aptlf='dpkg -L'
        alias aptclean='sudo apt-get clean'
        alias aptro='sudo apt-get autoremove'
        alias aptaddrep='sudo add-apt-repository'
        ;;
esac

alias smount='sudo mount'
alias ksp='ksuperkey'



type hub &> /dev/null && alias git=hub
alias ga='git add'
alias gpl='git pull'
alias g='git'
alias gp='git push'
alias gc='git commit -v'
alias gm='git commit -vm'
alias gs='git status'
alias gd='git diff'
alias gfp='git format-patch'
alias gch='git checkout'
alias gb='git branch'
alias gpom='git push origin master'
alias gplom='git pull origin master'
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
gpr() { 
    (( $# == 0 )) && target="origin" || target="$1"
    git config remote.$target.fetch "+refs/pull/*/head:refs/remotes/$target/pr/*" && git fetch --all
}


alias zshrc='$EDITOR ~/.zshrc'

bdf(){if [[ $# != 1 ]]; then echo "bdf requires one argument";else echo -en "$(btrfs fi df $1 | head -n1 | awk -F= '{print $2}' | awk -F, '{print $1}')" && echo " used out of $(df -h $1 | tail -n1 | awk '{print $2"iB"}')\n";fi}
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'
alias less='less -R'

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep --color'
alias -g L="| less"
alias -g LL="|& less"
alias -g CA="|& cat -A"
alias -g NE="|& /dev/null"
alias -g NUL="&> /dev/null"
alias DATE='$(date "+%Y-%m-%d")'
alias edit='$EDITOR'


alias dud='du --max-depth=1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias p='ps -ef'
alias sortnr='sort -n -r'

#systemd
sys_user_commands=(
  list-units is-active status show help list-dependencies list-unit-files
  is-enabled list-jobs show-environment reboot)

sys_sudo_commands=(
  start stop reload restart try-restart suspend isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment)

for c in $sys_user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sys_sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
alias sc-dr='sudo systemctl daemon-reload'
mac_user_commands=(
    list-images image-status show-image list-transfers list
    status show)
mac_sudo_commands=(
    start login enable disable poweroff reboot terminate kill copy-to
    copy-from bind clone rename read-only remove pull-tar pull-raw 
    pull-dkr cancel-transfer)
for d in $mac_user_commands; do alias mc-$d="machinectl $d"; done
for d in $mac_sudo_commands; do alias mc-$d="sudo machinectl $d"; done
alias snpr='sudo snapper'

##Functions

#Web Search
web_search(){
    # get the open command
    local open_cmd
    if [[ $(uname -s) == 'Darwin' ]]; then
      open_cmd='open'
    else
      open_cmd='xdg-open'
    fi
  
    # check whether the search engine is supported
    if [[ ! $1 =~ '(google|bing|yahoo|duckduckgo)' ]];
    then
      echo "Search engine $1 not supported."
      return 1
    fi
  
    local url="http://www.$1.com"
  
    # no keyword provided, simply open the search engine homepage
    if [[ $# -le 1 ]]; then
      $open_cmd "$url"
      return
    fi
    if [[ $1 == 'duckduckgo' ]]; then
    #slightly different search syntax for DDG
      url="${url}/?q="
    else
      url="${url}/search?q="
    fi
    shift   # shift out $1
  
    while [[ $# -gt 0 ]]; do
      url="${url}$1+"
      shift
    done
  
    url="${url%?}" # remove the last '+'
    
    $open_cmd "$url"
}

alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

#Make alias with 'sudo' infront of it (stolen from grml-zsh-config)
salias() {
    emulate -L zsh
    local only=0 ; local multi=0
    local key val
    while [[ $1 == -* ]] ; do
        case $1 in
            (-o) only=1 ;;
            (-a) multi=1 ;;
            (--) shift ; break ;;
            (-h)
                printf 'usage: salias [-h|-o|-a] <alias-expression>\n'
                printf '  -h      shows this help text.\n'
                printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
                printf '          be careful using this option.\n'
                printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
                return 0
                ;;
            (*) printf "unkown option: '%s'\n" "$1" ; return 1 ;;
        esac
        shift
    done

    if (( ${#argv} > 1 )) ; then
        printf 'Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}" ;  val="${1#*\=}"
    if (( EUID == 0 )) && (( only == 0 )); then
        alias -- "${key}=${val}"
    elif (( EUID > 0 )) ; then
        (( multi > 0 )) && val="${val// ; / ; sudo }"
        alias -- "${key}=sudo ${val}"
    fi

    return 0
}

#Extract
function extract() {
  local remove_archive
  local success
  local file_name
  local extract_dir

  if (( $# == 0 )); then
    echo "Usage: extract [-option] [file ...]"
    echo
    echo Options:
    echo "    -r, --remove    Remove archive."
    echo
  fi

  remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0 
    shift
  fi

  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" 1>&2
      shift
      continue
    fi

    success=0
    file_name="$( basename "$1" )"
    extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
    case "$1" in
      (*.tar.gz|*.tgz) tar xvzf "$1" ;;
      (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
      (*.tar.xz|*.txz) tar --xz --help &> /dev/null \
        && tar --xz -xvf "$1" \
        || xzcat "$1" | tar xvf - ;;
      (*.tar.zst) tar -I zstd -xvf "$1" ;;
      (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null \
        && tar --lzma -xvf "$1" \
        || lzcat "$1" | tar xvf - ;;
      (*.tar) tar xvf "$1" ;;
      (*.gz) gunzip "$1" ;;
      (*.bz2) bunzip2 "$1" ;;
      (*.xz) unxz "$1" ;;
      (*.lzma) unlzma "$1" ;;
      (*.Z) uncompress "$1" ;;
      (*.zip|*.war|*.jar) unzip "$1" -d $extract_dir ;;
      (*.rar) unrar x -ad "$1" ;;
      (*.7z) 7za x "$1" ;;
      (*.deb)
        mkdir -p "$extract_dir/control"
        mkdir -p "$extract_dir/data"
        cd "$extract_dir"; ar vx "../${1}" > /dev/null
        cd control; tar xzvf ../control.tar.gz
        cd ../data; tar xzvf ../data.tar.gz
        cd ..; rm *.tar.gz debian-binary
        cd ..
      ;;
      (*) 
        echo "extract: '$1' cannot be extracted" 1>&2
        success=1 
      ;; 
    esac

    (( success = $success > 0 ? $success : $? ))
    (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
    shift
  done
}

alias x=extract

function catsay(){
    cat $1 | cowsay
}

function catthink(){
    cat $1 | cowthink
}

mkaur(){
    local scriptdir=~/bin
    local aurpkgdir=~/aur-packages
    local auropts
    local filelist
    while [[ $(head -c1 <<<$1) == "-" ]]; do
        auropts+=" $1"
        shift
    done
    local fulldir="$aurpkgdir/$1"
    if [[ ! -d "$fulldir" ]]; then
        echo "$fulldir does not exist"
        return 1
    fi
    for file in "${fulldir}"/*; do
        filelist+=" $file"
    done
    eval "$scriptdir/mkaur $auropts $filelist"

}


##Plugins
for i in ~/.zsh_plugins/*.zsh; do
    source $i
done

# Make copying commands from the internet easier s.t. `$ ls` executes ls
function $ { eval "$@" } 


export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
source ~/.local/bin/virtualenvwrapper.sh

type rustup &> /dev/null && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

if [[ -f ~/.config/ranger/rc.conf ]]; then
    export RANGER_LOAD_DEFAULT_RC=FALSE
fi

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

export TEXMFHOME="/urs/local/share/texmf"
export R_LIBS_USER="~/.local/share/R"

emulate sh -c 'source /etc/profile.d/snapd.sh'

log50() { kubectl -nchecks logs -ljob-name="$1" }

if [[ -f /usr/share/nnn/quitcd/quitcd.bash_zsh && -z $NNN_SOURCED ]]; then
    NNN_SOURCED=1
    source /usr/share/nnn/quitcd/quitcd.bash_zsh
    alias n='n -dea'
    #alias ls='n'
    #alias l='ls'
    type pistol &> /dev/null && export "USE_PISTOL=1"
    export NNN_PLUG='s:preview-tui'
    [[ -n "$NNNLVL" ]] && PROMPT="N$NNNLVL $PROMPT"
    alias ncp="cat ${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection} | tr '\0' '\n'"
fi

alias ls='ls --color -F --group-directories-first'
alias l='ls -lh'  
alias ll='ls -lh'
alias la='ls -lAFh' 
alias lr='ls -tRFh'  
alias lt='ls -ltFh'   
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1FcArt'
alias lrt='ls -1Fcrt'
alias sl='ls'
