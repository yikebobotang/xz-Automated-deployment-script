

## 环境要求
- 操作系统：CentOS 7+
- Ansible 版本：2.9+ 
- 目标主机网络互通
- 使用root安装

## 使用方法
1. **准备环境**
   - 安装Ansible
   - dnf install ansible
   - 配置主机免密登录
   - 修改 `hosts/hosts` 文件，配置集群节点信息

2. **配置参数**
   - 修改 `hosts/hosts` 中的变量参数，如 Docker 安装目录、Harbor 配置等
   - 根据需要调整各角色中的任务文件

3. **执行部署**
   ```bash
   # 运行启动脚本
   ./start.sh
   
   # 或直接运行 Ansible 剧本
   ansible-playbook -i hosts/hosts setup.yaml
   ```

## 角色说明
### docker
负责 Docker 和 cri-dockerd 的安装与配置，包括：
- 安装 Docker 服务
- 修改 Docker 配置（存储目录、镜像加速等）
- 安装 cri-dockerd 容器运行时
- 安装 docker-compose 工具

### k8s
负责 Kubernetes 集群的安装与配置，包括：
- 安装 kubelet、kubeadm、kubectl 组件
- 初始化 Kubernetes 主节点
- 配置集群网络

### harbor
负责 Harbor 镜像仓库的部署，包括：
- 安装 Docker Compose
- 配置 Harbor 参数
- 启动 Harbor 服务

### rancher
负责 Rancher 管理平台的部署，提供 Kubernetes 可视化管理界面

### join-worker
负责将工作节点加入 Kubernetes 集群

### remove-worker
负责从 Kubernetes 集群中移除工作节点，包括：
- 停止相关服务
- 清理节点配置

## 配置示例
`hosts/hosts` 文件配置示例：
```ini
# 所有主机
[all-server]
192.168.0.110 host_name=k8s-master01
192.168.0.111 host_name=k8s-worker02

# 安装 harbor 主机
[harbor]
192.168.0.110

# 安装 k8s 主机
[k8s]
192.168.0.110 k8s_role=master gpu=0
192.168.0.111 k8s_role=worker gpu=0

# 加入 k8s 主机
[join-worker]
192.168.0.111 host_name=k8s-worker01 k8s_role=worker gpu=0

# 移除 k8s 主机
[remove-worker]
192.168.0.111 host_name=k8s-worker01 

[all:vars]
ansible_ssh_port=22
ansible_ssh_user=root
ansible_ssh_pass=newerabc@123

docker_home_dir=/data/docker
harbor_home=/data/harbor
harbor_host=192.168.0.110
harbor_admin_password=Harbor12345
harbor_port=8888
```

## 注意事项
1. 确保所有节点的时间同步，建议使用 NTP 服务（待完善安装ntp服务）
2. 确保各节点之间网络通畅，建议使用 ping 命令测试
3. 确保各节点之间可以通过 SSH 登录，建议使用 ssh 命令测试



## 维护与更新
- 定期更新 Ansible 角色以修复漏洞和添加新功能
- 升级 Kubernetes 版本前请仔细阅读官方文档
- 修改配置后建议先在测试环境验证

## 故障排除
- 检查 Ansible 执行日志以定位问题
- 验证主机网络连接和权限设置
- 检查 Docker 和 Kubernetes 服务状态