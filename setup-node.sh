#Configuring Hostnames
cat node-list.txt | while read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME
do
  echo $IP_ADDRESS $HOST_NAME $SHORT_NAME >> /etc/hosts
done

cat node-list.txt | while read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME
do
  if [ "$IP_ADDRESS" = "$1" ]
  then
    sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=$HOST_NAME/g" /etc/sysconfig/network
  fi
done

#Setup passwordless SSH
rm -rf ~/.ssh
mkdir ~/.ssh
cat id_rsa.pub >> ~/.ssh/authorized_keys

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

#Configure local repos
cp *.repo /etc/yum.repos.d/
