
      #########.
     ########",#:
   #########',##".
  ##'##'## .##',##.
   ## ## ## # ##",#.
    ## ## ## ## ##'
     ## ## ## :##
      ## ## ##."

# Create symlink of .brew in personal sgoinfre
rm -rf $HOME/.brew
rm -rf /sgoinfre/students/$USER/homebrew
mkdir -p /sgoinfre/students/$USER/homebrew
ln -s /sgoinfre/students/$USER/homebrew $HOME/.brew

# Delete and reinstall Homebrew from Github repo on symlinked destination
git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew

# Create .brewconfig script in home directory 
cat > $HOME/.brewconfig.zsh <<EOL
# HOMEBREW CONFIG
# Add brew to path
export PATH=\$HOME/.brew/bin:\$PATH
# Set Homebrew temporary folders
export HOMEBREW_CACHE=/tmp/\$USER/Homebrew/Caches
export HOMEBREW_TEMP=/tmp/\$USER/Homebrew/Temp
mkdir -p \$HOMEBREW_CACHE
mkdir -p \$HOMEBREW_TEMP
# If NFS session
# Symlink Locks folder in /tmp
HOMEBREW_LOCKS_TARGET=/tmp/\$USER/Homebrew/Locks
HOMEBREW_LOCKS_FOLDER=\$HOME/.brew/var/homebrew/locks
mkdir -p \$HOMEBREW_LOCKS_TARGET
mkdir -p \$HOMEBREW_LOCKS_FOLDER
# Symlink to Locks target folders
# If not already a symlink
if ! [[ -L \$HOMEBREW_LOCKS_FOLDER && -d \$HOMEBREW_LOCKS_FOLDER ]]
then
 echo "Creating symlink for Locks folder"
 rm -rf \$HOMEBREW_LOCKS_FOLDER
 ln -s \$HOMEBREW_LOCKS_TARGET \$HOMEBREW_LOCKS_FOLDER
fi
EOL

# Add .brewconfig sourcing in your .zshrc if not already present
if ! grep -q "# Load Homebrew config script" $HOME/.zshrc
then
cat >> $HOME/.zshrc <<EOL
# Load Homebrew config script
source \$HOME/.brewconfig.zsh
EOL
fi

source $HOME/.brewconfig.zsh
rehash
brew update

echo "\nPlease open a new shell to finish installation" 
