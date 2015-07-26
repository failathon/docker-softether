# Docker image for SoftEther VPN

Credit to cnf, this image is a fork from https://github.com/cnf/docker-softether, and to the SoftEther VPN project for providing an easy and extensible VPN platform for me to use :)

Will deploy a fully functional [SoftEther VPN](https://www.softether.org) server as a docker image and is intended for deployment on Amazon Web Service's EC2 Container Service (ECS), but could be deployed anywhere.

![overview diagram](https://raw.githubusercontent.com/failathon/docker-softether/master/misc/overview.png)

This project also lives in Docker hub as [failathon/softether](https://registry.hub.docker.com/u/failathon/softether/)

Use the SoftEther VPN client from [https://www.softether.org/5-download](https://www.softether.org/5-download) to connect to this service.

## Run in ECS

### First, Create a ECS Task Definition

#### Container Definition

1. set Container Name to desired name
2. set Image to failathon/softether
3. set CPU units to 900
4. set Memory to 750
5. enable Essential
6. set Port Mappings to 443:443 TCP (Host:Container) and 1194:1194 UDP
7. set Environment Variables
  * VPNUSER=your_user_here
  * VPNPASS=your_password_here
        
### Second, Create a Cluster
1. Create a cluster with any name you prefer
2. Within the cluster, now create a service, selecting the task definition you created before (i.e. softether-task:1)
3. Set the service name to a name you prefer (i.e. softether-service)
4. Set the number of tasks to 1 - this will create a single VPN service hosted on a single 
5. Leave the Load Balancer set to __No ELB__

### Third, Drink your coffee and prepare to connect
:) Wait for ECS to spawn your new service


# Alternate methods and other tidbits

## Running direct from EC2 instance

    docker run -d -e VPNUSER=<userhere> -e VPNPASS=<passhere> --net host --name vpn-server failathon/softether

## EC2 Instance for ECS 101
For those who have not used ECS before, ensure that:

* Use an ECS-optimized AMI (ie. ami-27212417 in Community AMIs)
* IAM role selected should contain:
  * AmazonEC2ContainerServiceFullAccess
  * AmazonEC2ContainerServiceRole
  * Trusted Entity is ec2.amazonaws.com
* *Security Group* must allow SSH (22/tcp) and HTTPS (443/tcp) are allowed for Inbound traffic
* Set *User Data* is set to
```bash
#!/bin/bash
echo ECS_CLUSTER=cluster_name_here >> /etc/ecs/ecs.config
```
