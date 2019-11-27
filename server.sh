#!/usr/bin/env bash
#set -e 
#set -x

config_file_dir="/etc/shadowsocks"
config_file_path="${config_file_dir}/config.json"

setup_config()
{
    test -d $config_file_dir || mkdir $config_file_dir -p
    cat << EOF >$config_file_path
    {
      "server":"0.0.0.0",
      "_comment": {
        "6999":"zhangsan"
      },
      "port_password": {
        "6999":"zhangsan_mima"
      },
      "local_address":"127.0.0.1",
      "local_port":1081,
      "timeout": 300,
      "method": "aes-256-cfb",
      "fast_open": false,
      "workers": 1,
     "prefer_ipv6": false
   }
EOF

    echo "$(cat ${config_file_path})"
}

setup_server_app()
{
    sudo yum update -y
    sudo yum install vim -y
    sudo yum install python-setuptools && easy_install pip==9.0.3
    sudo pip install shadowsocks
}

add_startup()
{
    cat << EOF > /lib/systemd/system/vpns.service
[Unit]
Description=Shadowsocks server
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/usr/bin/ssserver -c /etc/shadowsocks/config.json -d start
ExecStop=/usr/bin/ssserver -c /etc/shadowsocks/config.json -d stop

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    cat /lib/systemd/system/vpns.service
}

print_help()
{
    echo "  --------------------------------请执行--------------------------------------"
    echo " \"systemctl restart vpns\"               来重启服务"
    echo " \"ps -C ssserver h\"                     可查看服务是否正在运行"
}

main()
{
    setup_server_app
    setup_config
    add_startup
    systemctl enable vpns.service
}

main
print_help


