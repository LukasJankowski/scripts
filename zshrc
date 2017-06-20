# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# RubyGems Path
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# GOPATH env variable so that it doesnt clutter the home dir
export GOPATH=/home/lj/Code/Go/Projects

# GnuGPG for pinentry
export GPG_TTY=$(tty)

# Exploit-Database Path
export PATH="/opt/exploit-database:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/home/lj/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell" # robbyrussell agnoster

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git npm zsh-autosuggestions k)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_ed25519"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

relock() {
	if [ ! -z $1 ] ; then
		case $1 in
			lock)
				sh ~/.config/lock.sh
				;;
			logout)
				i3-msg exit
				;;
			sleep)
				relock lock && systemctl suspend
				;;
			reboot)
				systemctl reboot
				;;
			shutdown)
				systemctl poweroff
				;;
			*)
				echo "Shutdown-Helper: $0 {lock|logout|sleep|reboot|shutdown}"
				;;
		esac
	fi	
}

# file manager
alias explorer="ranger"


# set the music up
music() {
    killall -q mopidy
    mopidy > /dev/null 2>&1 &
    ncmpcpp
}

# set upload
upload() {
    if [ ! -z $1 ] ; then
        rsync -azrvh --progress $@ upload:"${@: -1}"
    else
        echo "At least one argument must be given. (Last argument is destination)"
    fi
}
# set download
download() {
    if [ ! -z $1 ] ; then
        par=
        for obj in "$@"
        do
            par="$par upload:$obj"
        done
        rsync -azrvh --progress $(echo $par | sed -e 's/^[ ]*//') .
    else
        echo "At least one argument must be given."
    fi
}
# aliases for uploads / downloads
alias up="upload"
alias down="download"
#alias push="upload"
#alias pull="download"

# alias k (ls variant)
alias k="k -Ah"
alias l="k -Ah"

# better diffing
alias diff="icdiff"

# convert currency
currency() {
    wget -qO- "http://www.google.com/finance/converter?a=$1&from=$2&to=$3" | sed '/res/!d;s/<[^>]*>//g'
}

# worldmapping
alias map="telnet mapscii.me"
alias worldmap="map"

# speedtest
alias speedtest="python ~/Code/Python/speedtest.py --bytes"
 
# vim alias
alias vi="vim"

# sudo alias
alias fuck="sudo \$(fc -ln -1)"

# compare two files for identical results
alias comparefiles="bash ~/Code/Bash/comparefiles.sh"

# get the current weather
alias weather="curl wttr.in/Hamburg"

# initially connect msf to postgres
msfconsole() {
    sudo systemctl start postgresql.service
    sudo msfconsole --quiet -x "db_connect ${USER}@msf"
}

# start math
# alias math="bc -i"
alias math="insect"

# hex viewer similar to hexdump
alias hex="xxd"

# browser settings
alias browser="google-chrome-stable"
alias chrome="browser"

# transcoder helper
hextoascii() {
    if [ $# -eq 1 ]; then
        echo -n $1 | xxd -r -p
    else
        echo "[!] 1 argument needs to be given to be transcoded."
    fi
}
asciitohex() {
    if [ $# -eq 1 ]; then
        echo -n $1 | od -t x1 | cut -c 8- | sed s/' '//g
    else
        echo "[!] 1 arugment needs to be given to be transcoded."
    fi
}


# archive extraction helper
extract() {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2) tar xvjf $1 ;;
			*.tar.gz) tar xvzf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xvf $1 ;;
			*.tbz2) tar xvjf $1 ;;
			*.tgz) tar xvzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.7z) 7z x $1 ;;
			*) echo "Unsupported format, unable to extract '$1'" ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

# get the IP both external and inetrnal
myip() {
	if [ $# -eq 1 ]; then
		case $1 in
			"internal"|"in"|"i"|"-i") echo `ip -4 addr | grep inet | awk '{ print $2 }' | grep -v 127.0.0.1 | sed 's/\/.*//'` ;;
			"external"|"ex"|"e"|"-e") echo `dig +short myip.opendns.com @resolver1.opendns.com` ;;
			*) echo "Unknown parameter '$1'" ;;
		esac
	else 
		echo -e Internal IP: `ip -4 addr | grep inet | awk '{ print $2 }' | grep -v 127.0.0.1 | sed 's/\/.*//'`'\n'External IP: `dig +short myip.opendns.com @resolver1.opendns.com`
	fi
}

# current battery status
alias battery="acpi -b"

# show ports / connections currently in use
alias ports="ss -tu -r"

# powersaving options
alias powersave="sudo powertop"

# display more information in listings
alias ll="ls -lh"
alias la="ls -lha"

# sublime text alias
alias subl="subl3 -a"

# mail for mutt
alias email="mutt"
alias mail="mutt"

# alias vpn client
alias ovpn="sudo openvpn"

# package management
alias package-install="sudo pacman -S"
alias package-remove="sudo pacman -Runs"
alias package-update="sudo pacman -Syu"


# navigate home
alias h="cd ~"

# clear console
alias c="clear"

# vim alias
alias v="vim"

# sudo alias
alias s="sudo"

# combined alias
alias sv="sudo vim"

# quit alias
alias q="exit"

# for cd typos
alias cd..="cd .."

# banner alternative
alias banner="reset;neofetch"

#
alias unix="curl -L http://git.io/unix"

# Timer
timer() {
	if [ $# -eq 1 ]; then
		sleep $1 &> /dev/null && ffplay -nodisp -autoexit -loglevel quiet ~/Music/alertsiren.mp3
		echo "Time's up!"
	fi
}

# current time
alias now="date +'%T'"

# change workspaces from commandline
workspace() {
	if [ $# -eq 1 ]; then
		xdotool key alt+$1
	fi
}

# Networking helper
alias nm="sudo bash ~/Code/Bash/networking.sh"
alias network="nm"

# network traffic
alias traffic="sudo iptraf-ng"

# encryption helper
encrypt() {
    if [ -f $1 ]; then
        echo "[*] Encrypting file $1"
        gpg -c --cipher-algo AES256 -o "$1.aes" $1 > /dev/null 2>&1
        if [ -f "$1.aes" ]; then
            echo "[+] File encrypted: $1 --> $1.aes"
        else
            echo "[!] Error encrypting file $1"
        fi
    else
        echo "[*] Encrypting string"
        export GPG_TTY=$(tty)
        echo "[+] Encrypted string:"
        echo $1 | gpg -c --cipher-algo AES256 -q | base64
        echo "[+] End Encrypted string"
    fi
    echo "[*] Done."
}

decrypt() {
    if [ -f $1 ]; then
        echo "[*] Decrypting file $1"
        BASENAME=$(basename $1 .aes)
        gpg -d -o $BASENAME $1 > /dev/null 2>&1
        if [ -f $BASENAME ]; then
            echo "[+] File decrypted: $1 --> $BASENAME"
        else
            echo "[!] Error decrypting file $1"
        fi
    else
        echo "[*] Decrypting string"
        export GPG_TTY=$(tty)
        echo "[+] Decrypted string:"
        echo -n $1 | base64 --decode | gpg -d -q 2>/dev/null
        if [ $? -eq 2 ]; then
            echo "[!] Error decrypting string"
        else
            echo "[+] End Decrypted string"
        fi
    fi
    echo "[*] Done."
}

# convert handshakes to john
cap2john() {
   if [ $# -eq 2 ]; then
       if [ -f $1 ]; then
           echo "[*] Converting $1 to john format"
           echo "[*] Converting .cap to .hccap"
           BASENAME=$(basename $1 | cut -d. -f1)
           cap2hccap64.bin -e $2 $1 "$BASENAME.hccap"
           echo "[*] Converting .hccap to .john"
           hccap2john "$BASENAME.hccap" > "$BASENAME.john"
           echo "[*] Removing .hccap again"
           rm "$BASENAME.hccap"
           echo "[+] Handshake for $2 converted in $BASENAME.john"
       else
            echo "[!] $1 is not a valid file"
       fi
   else
       echo "cap2john: $0 handshake.cap ESSID"
   fi
}

# IP Geolocation finder
geoip() {
    if [ $# -eq 1 ]; then
        IP=$1
    else
        IP=    
    fi
    GEODATA=$(wget -qO- http://ip-api.com/json/$IP)
    if [ -z $IP ]; then
        IP="localhost"
    fi
    STATUS=$(jq '.status' <<< $GEODATA)
    if [[ "$STATUS" == '\"fail\"' ]]; then
        echo "[!] Failed to receive information about $IP"
        echo "[!] Message: " $(jq '.message' $GEODATA)
    else
        COUNTRY=$(jq '.country' <<< $GEODATA)
        COUNTRYCODE=$(jq '.countryCode' <<< $GEODATA)
        REGIONNAME=$(jq '.regionName' <<< $GEODATA)
        REGIONCODE=$(jq '.region' <<< $GEODATA)
        CITY=$(jq '.city' <<< $GEODATA)
        ZIP=$(jq '.zip' <<< $GEODATA)
        LAT=$(jq '.lat' <<< $GEODATA)
        LON=$(jq '.lon' <<< $GEODATA)
        ISP=$(jq '.isp' <<< $GEODATA)
        AS=$(jq '.as' <<< $GEODATA)
        
        echo "[+] Received geo-information about $IP"
        if [[ "localhost" == "$IP" ]]; then
            echo "IP:      " $(jq '.query' <<< $GEODATA)
        else
            echo "IP:       \"$IP\""
        fi
        echo "Country:  $COUNTRY / $COUNTRYCODE"
        echo "Region:   $REGIONNAME / $REGIONCODE"
        echo "City:     $ZIP $CITY"
        echo "Location: lat $LAT / lon $LON"
        echo "Provider: $ISP / $AS"
    fi
}

# Check hash online
hashcrack() {
    if [ $# -eq 1 ]; then 
        echo "[*] Hash: $1" 
        echo "[*] Trying online services to crack the hash"
        RESULT=$(wget -qO- "https://hashes.org/api.php?act=REQUEST&key=[GETYOUROWN]&hash=$1")
        REQUEST=$(jq '.REQUEST' <<< $RESULT)
        if [[ "$REQUEST" == '\"NOT FOUND\"' ]]; then
            echo "[-] Hash was not found online"
            return         
        fi
        echo "[+] Plaintext found: "
        FINAL=$(jq '.' <<< $RESULT)
        echo $FINAL
    else
        echo "[!] $0 hash must be given as parameter"
    fi
}


# MAC Identifier
alias mactovendor="bash ~/Code/Bash/mac_identifier.sh"

# News reader
alias news="newsbeuter 2>/dev/null"

# System overview
alias sysinfo="glances"
alias monitor="sysinfo"

# Translation
alias trans="trino"
alias translate="trans"

# Screensaver gizmo
screensaver() {
    VAL=$(shuf -i0-9 -n1)
    bash ~/Code/Bash/pipes.sh -p 5 -r 0 -t $VAL
}
alias pipes="screensaver"
