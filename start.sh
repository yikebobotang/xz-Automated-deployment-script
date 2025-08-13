#!/bin/bash
# 一键部署脚本

init_server() {
    ansible-playbook -i hosts/hosts --tags="init" setup.yaml -f 20
}

install_docker() {
    ansible-playbook -i hosts/hosts --tags="docker" setup.yaml -f 20
}

install_harbor() {
    ansible-playbook -i hosts/hosts --tags="harbor" setup.yaml -f 20
}
join_worker() {
    ansible-playbook -i hosts/hosts --tags="join-worker" setup.yaml -f 20
}
remove_worker() {
    ansible-playbook -i hosts/hosts --tags="remove-worker" setup.yaml -f 20
}
menu_list() {
    echo "##################################################"
    echo "#                  一键部署脚本                   #"
    echo "##################################################"
    echo "      [1]   所有主机进行系统初始化操作              "
    echo "      [2]   安装docker                              "
    echo "      [3]   安装harbor                              "
    echo "      [A]   加入k8s集群                              "
    echo "      [R]   移除k8s集群                              "
    echo "##################################################"
    read -r -p "请输入你的编号来选择进行安装【1-3】: " number
}

main() {
    if [[ "$1" == "$0" ]];then
        while :
        do
            menu_list
            case $number in
            1)
                init_server
                ;;
            2)
                install_docker
                ;;
            3)
                install_harbor
                ;;
            A)
                join_worker
                ;;
            R)
                remove_worker
                ;;
            Q|q)
                break
                ;;
            esac
        done           
    else
        echo "参数有误"
        exit 5
    fi
}
# 调用入口函数
main "$0"

