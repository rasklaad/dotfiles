# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

xss-lock -n /home/user/lib/xsecurelock/dimmer -l -- env XSECURELOCK_SAVER=saver_blank XSECURELOCK_PASSWORD_PROMPT=time XSECURELOCK_SHOW_DATETIME=1 xsecurelock &
