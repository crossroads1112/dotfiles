dir=~/.dotfiles # dotfiles directory
olddir=~/.dotfiles_old # old dotfiles backup directory
lnfiles="zshrc gvimrc vimrc tmux.conf vimperatorrc zsh_plugins mailcap mutt muttrc" # list of files/folders to symlink in homedir
bold(){
    echo "$(tput bold)$@$(tput sgr0)"
}

bold "Decrypting mutt passwords"
scrypt enc $dir/mypw.gpg.bfe > ~/.mypw.gpg

bold "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
bold "Done"

bold "Changing to the $dir directory ..."
cd $dir
bold "Done"

for lnfile in $lnfiles; do
    bold "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$lnfile $olddir/
    bold "Creating symlink to $lnfile in home directory."
    ln -s $dir/$lnfile ~/.$lnfile
done

[[ -d ~/.vim ]] && rm -rf ~/.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
sh /tmp/installer.sh ~/.vim/dein
