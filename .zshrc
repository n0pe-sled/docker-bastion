if [ ! -d $HOME/.logs ]; then
    mkdir $HOME/.logs 2> /dev/null
fi

CURDATE=`date '+%Y%m%d_%H%M%S.%N_%Z'`
command_output=$(basename $(ps -f -p $PPID -o comm= 2>/dev/null))
# Compare the output to "sh"
if [ "$command_output" = "sh" ]; then
    # Currently in Script session
else
    # Not in Script session
    script -f -c "/usr/bin/zsh" $HOME/.logs/$CURDATE.log
    exit
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.powerlevel10k/powerlevel10k.zsh-theme

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/go/bin
alias pip=pip3
alias python=python3
alias help='echo "Tooling Installed:\nPowershell\nGCloud\nMetasploit\ndirsearch\ndnsrecon\nimpacket\nbloodhound.py\nsqlmap\ncertipy-ad\nCoercer\npyldapsearch\npysqlrecon\nspraycharles\nPMapper\nScoutSuite\ntrevorspray\ntrevorproxy\ncerti\nenum4linux-ng\nrecon-ng\nPetitPotam\npre2k\npywhisker\nPKINITtools\nsccmhunter\nwmiexec-Pro\nbf-aws-perms-simulate\nbf-aws-permissions\nysoserial\ngodap\nldapper\nkerbrute\nTeamsUserEnum\ncloudfox\nnikto\nmikto\nPowerSploit\nMicroBurst\nBARK"'
alias jq-aws="jq -r '@sh \"export AWS_ACCESS_KEY_ID=\(.Credentials.AccessKeyId) AWS_SECRET_ACCESS_KEY=\(.Credentials.SecretAccessKey) AWS_SESSION_TOKEN=\(.Credentials.SessionToken)\"'"
alias unset-aws="unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

