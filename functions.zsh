LS_LIMIT=400
function ls_limited()
{
    local file_count

    file_count=`ls | wc -l`
    if [[ $file_count -gt $LS_LIMIT ]]; then
	echo "Over $LS_LIMIT files were found; listing the first $LS_LIMIT"
	ls $__LS_FLAGS | head -$LS_LIMIT
    else
	ls $__LS_FLAGS
    fi
}

function knock {
    for port in $2 $3 $4; do
        nc $1 $port
        sleep 1
    done
}

function ov {
    sudo openvpn "/etc/openvpn/$1.conf"
}

# I often type this by mistake instead of !p
function 1p {
    local command=$(fc -l -n 1 -1 | sed -n -e '/^p/{p;q}')
    echo "$command"
    eval "$command"
}

# XXX cd !$ for git clone should work
