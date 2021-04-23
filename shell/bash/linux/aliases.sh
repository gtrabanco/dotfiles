alias flushDNS="sudo service network-manager restart" # sudo /etc/init.d/nscd restart.
alias flush=flushDNS
alias localip="ip -h -br -4 address"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Simulate pbcopy and pbpaste for copying to and from the pasteboard/clipboard
#
#   from: http://whereswalden.com/2009/10/23/pbcopy-and-pbpaste-for-linux/
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'