[[ $- != *i* ]] && return
##Pre stuff
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi
stty -ixon
[[ -f /etc/updates.txt ]] && head -n1 /etc/updates.txt && echo
##Prompt
user=chad
if (( EUID == $(id -u $user) )); then
    PROMPT="%(?,Ω,ω) %~/ "
else
    PROMPT="[%B%F{blue}%n%f%b@%m %B%40<..<%~%<< %b] %# "
fi

if [[ -z $DISPLAY ]]; then
    PROMPT="[%B%(?,%F{blue},%F{red})%n%f%b@%m %B%40<..<%~%<< %b] %# "
fi
RPROMPT="%B%(?..%?)%b"
pgrep mpd &>/dev/null || mpd &>/dev/null
#Make sure tmux is running
#[[ -z "$TMUX" ]] && exec tmux
##ZSH options
autoload -U compinit promptinit colors && colors
setopt completealiases auto_cd append_history share_history histignorealldups histignorespace extended_glob longlistjobs nonomatch notify hash_list_all completeinword nohup auto_pushd pushd_ignore_dups nobeep noglobdots noshwordsplit nohashdirs inc_append_history prompt_subst
promptinit
compinit -i
REPORTTIME=5
watch=(notme root)
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^R' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
if [[ -L /bin ]]; then
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:$HOME/bin:/usr/bin/core_perl:/usr/local/scripts:$HOME/.gem/ruby/2.2.0/bin"
else
    export PATH="/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$HOME/bin:/usr/bin/core_perl:/usr/local/scripts"
fi
which vim > /dev/null 2>&1 && export EDITOR="vim" || export EDITOR="vi"
which firefox > /dev/null 2>&1 && export BROWSER="firefox"


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
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'
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
alias n="ncmpcpp"
alias snp='sudo snp'
alias mstat='dstat -tcmnd --top-cpu --top-mem'
alias nfs='mount ~/Cloud/nfs'
alias dc='cd'
alias z='source ~/.zshrc'
alias pg='ps -ef | grep --color'
alias svim='sudoedit'
alias vi='vim'
alias ivm='vim'
alias e='exit'
alias q='exit'
alias ZZ='exit'
alias rmall='rm -rf -- *'
alias addto='todo.sh a $(date "+%Y-%m-%d)'
alias todo='todo.sh'
alias treset='sudo modprobe -r psmouse; sudo modprobe psmouse'
alias info='info --vi-keys'
alias -g pacupg-dev='~/bin/pacupg/pacupg'
alias ytau='youtube-dl --extract-audio --audio-format'
nport(){nmap -p $1 --open -sV "$(echo "$(ip route get 8.8.8.8 | awk -F'src ' '!/cache/{print $2}' | tr -d ' ')/$2")"}
alias tarcheck='ssh mmfab-server -l root jexec 3 tarsnap --list-archives --keyfile /root/tarsnap.key | sort 2>/dev/null || ssh mmfab-server-away -l root jexec 3 tarsnap --list-archives --keyfile /root/tarsnap.key | sort'
alias snapnum='echo $(($(snapper list | wc -l)-3))'
for i in fuck damnit please; do
    alias $i='source ~/.zshrc;fc -ln -1; sudo -E $(fc -ln -1)'
done
rman(){
  local count=0
  while true; do 
      count=$(($count+1))
      command=$(command ls -1 /usr/bin | sort -R | head -n1); 
      if [[ "$(man -k "${command}" 2>&1 | awk -F': ' '{print $2}')" != "nothing appropriate." ]] &>/dev/null; then
          man "$command"
          break 
      elif (($count == 5)); then
          echo "Five failed attempts at finding a suitable command. Aborting."
          break
      fi
  done 
}
gcco(){gcc -o ${1} ${1}.c}
rev(){ echo "r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"}
fj(){firejail -c $@ 2> /dev/null}
open(){gvfs-open $@ &> /dev/null}
ddp () {
	sudo dd if="$1" | pv -s $(du "$1" | awk '{print $1}') | sudo dd of="$2"
}
gt() {
    to="${1}";
    shift
    text=$(echo "${@}" | sed -e "s/^.. //" -e "s/[\"'<>]//g");
    wget -U "Mozilla/5.0" -qO - "http://translate.google.com/#auto/${to}/${text}" 
}    
up() {
    local dest=".." 
    local limit=${1:-1} 
    for ((i=2 ; i <= limit ; i++)); do 
         dest=$dest/..
    done 
    cd $dest
} 
export TERM=screen-256color

for i in mv cp; do
    which a${i} > /dev/null 2>&1 && alias $i="a${i} -g"
done > /dev/null

command grep '^DISTRIB_ID=' /etc/lsb-release | source /dev/stdin
distro=$(echo $DISTRIB_ID | awk '{print tolower($0)}')
unset DISTRIB_ID
case "$distro" in 
    arch) 
        pacin(){sudo pacman -S $@; pkgdump}
        pacins(){sudo pacman -U $@; pkgdump}
        pacre(){sudo pacman -R $@; pkgdump}
        pacrem(){sudo pacman -Rns $@; pkgdump}
        pacremc(){sudo pacman -Rnsc $@; pkgdump}
        aurin(){pacaur -S $@;  pkgdump}
        aurre(){pacaur -R $@; pkgdump}
        aurrem(){pacaur -Rns $@; pkgdump}
        aurremc(){pacaur -Rnsc $@; pkgdump}
        
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
        alias pacupga='pacupg -a; sudo abs'
        alias pacc='sudo pacman -Sc'
        alias paccc='sudo pacman -Scc'
        alias pacdown='sudo pacman -Sw'
        alias pacfile='pacman -Ql'
        
        alias yaconf='yaourt -C'
        alias aursu='pacaur -Syu --noconfirm'
        alias aurrep='pacaur -Si'
        alias aurreps='pacaur -Ss'
        alias aurloc='pacaur -Qi'
        alias aurlocs='pacaur -Qs'
        alias aurlst='pacaur -Qe'
        alias aurorph='pacaur -Qtd'
        alias aurupga='pacupg -a && sudo abs'
        alias aurmir='pacaur -Syy'
        alias aurmake='pacaur -Sw'
        alias aurcheck='pacaur -k'
        alias aurclean='pacaur -cc'
        alias aurup='aurploader -k -a -l ~/.config/aurploader'
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
bmount(){sudo mount -o compress=lzo,autodefrag,ssd,discard,space_cache,noatime,subvol=$1 /dev/mapper/cryptroot $2}
alias fmount='sudo mount -o compress=lzo,autodefrag,ssd,discard,space_cache,noatime /dev/mapper/cryptroot'
alias bootmnt='sudo mount -o compress=lzo,autodefrag,space_cache,noatime'
alias ksp='ksuperkey'

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

alias ga='git add'
alias gl='git pull'
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
alias glom='git pull origin master'

alias zshrc='vim ~/.zshrc'

bdf(){if [[ $# != 1 ]]; then echo "bdf requires one argument";else echo -en "$(btrfs fi df $1 | head -n1 | awk -F= '{print $2}' | awk -F, '{print $1}')" && echo " used out of $(df -h $1 | tail -n1 | awk '{print $2"iB"}')\n";fi}
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep --color'
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias DATE='$(date "+%Y-%m-%d")'
alias edit='vim'


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
