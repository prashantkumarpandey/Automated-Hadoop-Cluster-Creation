#Install and configure ambari server
read LIST_TYPE IP_ADDRESS HOST_NAME SHORT_NAME < node-list.txt
yum -y install ambari-server
./setup-ambari-server.exp
ambari-server start

#Install and configure ambari agent
yum -y install ambari-agent
sed -i "s/hostname=localhost/hostname=$HOST_NAME/g" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start
cat node-list.txt | while read LIST_TYPE IP_ADDRESS REST_LINE
do
  if [ "$LIST_TYPE" = "data" ]
  then
    ./setup-ambari-agent.exp root $1 $IP_ADDRESS
  fi
done

#Install cluster using Ambari Blueprint
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d @hdp-repo.json http://$HOST_NAME:8080/api/v1/stacks/HDP/versions/2.3/operating_systems/redhat6/repositories/HDP-2.3
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d @hdp-utils-repo.json http://$HOST_NAME:8080/api/v1/stacks/HDP/versions/2.3/operating_systems/redhat6/repositories/HDP-UTILS-1.1.0.20
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X POST -d @default-blueprint.json http://$HOST_NAME:8080/api/v1/blueprints/default-blueprint
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X POST -d @cluster-template.json http://$HOST_NAME:8080/api/v1/clusters/hdpdevcluster
sleep 120
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X GET http://$HOST_NAME:8080/api/v1/clusters/hdpdevcluster/requests/1 | grep progress_percent
