#Configuring Hostnames
cat node-list.txt | while read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME
do
  echo $IP_ADDRESS $HOST_NAME $SHORT_NAME >> /etc/hosts
done
read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME < node-list.txt
sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=$HOST_NAME/g" /etc/sysconfig/network
hostname $HOST_NAME
service network restart

#Install expect to automate SSH key generation
yum -y install expect
rm -rf ~/.ssh
mkdir ~/.ssh
./setupssh.exp
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#install jdk and set java home and path
rpm -ivh jdk-8u40-linux-x64.rpm
echo 'export JAVA_HOME=/usr/java/jdk1.8.0_40/' >> /etc/profile
echo 'PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

#Some other prerequisites as per Ambari document 
yum -y install ntp
service ntpd start
chkconfig ntpd on
ulimit -n 10000
cat thp.txt >> /etc/rc.local
service iptables stop
chkconfig iptables off
service ip6tables stop
chkconfig ip6tables off
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#Install http server to host local repositories
yum -y install httpd 
service httpd start
chkconfig httpd on
tar -zxvf ambari-2.1.1-centos6.tar.gz -C /var/www/html/
tar -zxvf HDP-2.3.0.0-centos6-rpm.tar.gz -C /var/www/html/
tar -zxvf HDP-UTILS-1.1.0.20-centos6.tar.gz -C /var/www/html/
cp *.repo /etc/yum.repos.d/

#Configure all other nodes
cat node-list.txt | while read LIST_TYPE IP_ADDRESS REST_LINE
do
  if [ "$LIST_TYPE" = "data" ]
  then
    ./setup-node.exp root $1 $IP_ADDRESS
  fi
done

#reboot this machine
reboot





