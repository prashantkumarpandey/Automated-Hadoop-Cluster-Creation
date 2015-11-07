#Install Ambari agent
read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME < ./node-list.txt
yum -y install ambari-agent
sed -i "s/hostname=localhost/hostname=$HOST_NAME/g" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start
