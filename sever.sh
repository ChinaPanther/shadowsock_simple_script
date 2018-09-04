#!/usr/bin/env bash
#set -e 
#set -x

config_file_dir="/etc/shadowsocks"
config_file_path="${config_file_dir}/config.json"

setup_config()
{
    test -d $config_file_dir || mkdir $config_file_dir
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

setup_server_app_centos()
{
    sudo yum update -y
    sudo yum install vim -y
    sudo yum install python-setuptools && easy_install pip==9.0.3
    sudo pip install shadowsocks
}

setup_server_app_ubuntu()
{
    sudo apt-get update  -y
    sudo apt-get install vim -y
    sudo apt-get install python-setuptools && easy_install pip==9.0.3
    sudo pip install shadowsocks
}

print_help()
{
    echo "  --------------------------------请执行--------------------------------------"
    echo " \"ssserver -c $config_file_path -d start\"               来启动服务"
    echo " \"nohup ssserver -c $config_file_path -d restart &\"     启动服务并在后台运行"
    echo " \"ps -C ssserver h\"                                     可查看服务是否正在运行"
}

main()
{
    cat /etc/issue | grep 'centos' -i
    if [ 0 -eq $? ]; then
        echo "OS Name : Centos"
        let OS_type=0
    fi

    cat /etc/issue | grep 'ubuntu' -i
    if [ 0 -eq $? ]; then
        echo "OS Name Ubuntu"
        let OS_type=1
    fi

    if [ 0 -eq $OS_type ]; then
        echo "1"
        setup_server_app_centos
    elif [ 1 -eq $OS_type ]; then
        echo "2"
        setup_server_app_ubuntu
    else
        exit
    fi
    setup_config
}

main
print_help


