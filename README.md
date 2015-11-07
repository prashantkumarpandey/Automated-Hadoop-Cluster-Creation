# Automated-Hadoop-Cluster-Creation
Automating Hdoop Cluster Installation
This is a demo to automate three nodes Hadoop cluster with minimal or no manual intervention. This is an oversimplified example for demonstration purpose, but it can be extended for a larger and complex cluster configuration.
For detailed explanation of scripts and related concepts visit www.teckstory.com

# Pre-requisites

 * Three VMs created using VirtualBox and CentOS 6.4 installed. This demo used CentOS 6.4 minimal ISO image for installation. This demo will use the first VM as Master and other two VMs as data nodes. This demo is tested with 4 GB RAM and 2 CPU Cores for master node VM whereas, 2 GB RAM and 1 CPU core for each data node VM.
 * Network connectivity and working ping from the master node to both data nodes.
 * VirtualBox Guest Additions installed for all three VMS. This is necessary to create shared folders. Create a shared folder on your master node VM and mount them. Download all scripts and files from this git project and place all of them in your shared folder. Make sure you are able to read these files from your master node VM.
 * Download JDK (jdk-8u40-linux-x64.rpm) from Oracle.  
 * Download following tarballs from HortonWorks. You can find a download location for your tarballs from [HowrtonWorks documentation.](http://docs.hortonworks.com/HDPDocuments/Ambari-2.1.0.0/bk_Installing_HDP_AMB/content/_hdp_stack_repositories.html)
 	* 	HDP-2.3.0.0-centos6-rpm.tar.gz
 	* 	HDP-UTILS-1.1.0.20-centos6.tar.gz
 	* 	ambari-2.1.1-centos6.tar.gz

# Manual preparation Activities

* Modify node_list.txt to update IP address and assign fully qualified hostnames for your VMs. You must correctly update actual IP addresses of you VMs however, you can choose any hostname or you can even use same hostnames as given in node_list.txt. The first line in node_list.txt is assumed to be a master.
* Modify cluster-template.json to update fqdn for your master hostname. This should match with the first line of node_list.txt.
* Modify hdp.repo and ambari.repo to update baseurl to fqdn for your master hostname.
* Modify hdp-repo.json and hdp-utils-repo.json to update baseurl to fqdn for your master hostname.

# Execute - First Script
* Login to your master node VM as root. Change your current directory to your shared folder which you have mounted. Execute prepare.sh script. You need to pass root password as a first and only parameter to this script. This demo made an assumption that root password for all three nodes is same.
* Once this script completes execution, it will reboot all VMs including master node VM.

# Execute - Second Script
* Login to your masters node VM as root. Mount your shared folder again because reboot may have lost it. Change your current directory to your shared folder. execute install-cluster.sh. You need to pass root password as a first and only parameter to this script. This demo made an assumption that root password for all three nodes is same.
* Login to Ambari web UI to monitor progress.
