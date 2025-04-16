#!/bin/sh -eux

iPacker='
This system is built by the iPacker project by Packer
More information can be found at https://github.com/iEchoxu/iPacker

Use of this system is acceptance of the OS vendor EULA and License Agreements.'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-ipacker'

    cat >> "$MOTD_CONFIG" <<IPACKER
#!/bin/sh

cat <<'EOF'
$iPacker
EOF
IPACKER

    chmod 0755 "$MOTD_CONFIG"
else
    touch /etc/motd
    chmod 0777 /etc/motd
    echo "$iPacker" >> /etc/motd
    chmod 0755 /etc/motd
fi
