# Overview 
## Vagrant - a tools for VMs

A tool for automating the creation and configuration of VMs.

Instead of having to do it via GUI, it's like creating a reproducable plan and setup for VMs.

Traditionally, vagrant has to be installed with ```su``` privilege and since Peak refuse to install it, we need to setup it in the VM.

But thankfully, there's a portable vagrant binary that you can setup without ```su``` access 


### Portable Vagrant Binary

    Portable vagrant binary can be downloaded from [Official hashiCorp DL page](https://developer.hashicorp.com/vagrant/install)


        1.) download and extract to your ```~/bin``` directory (create if you don't have one)

        2.) add the path to your own bin into ```~/.zshrc``` using

        ```export PATH="$HOME/bin:$PATH"```

        3.) restart the terminal or ```source ~/.zshrc```


## Vagrant Terminology & Basic Knowledge

- vagrant is directory based, you have to ```cd``` into where the ```Vagrantfile``` is before running the vagrant commands .. vagrant command will try to look for VMs with such specification and run on it's own environment.

- once up, it always on, consume resources until removed.

### workflow

Vagrant > Create VM > Provision VM


* Network configuration usually done before provisioning

BOX - see [HashiCorp Discover Vagrant Boxes](https://portal.cloud.hashicorp.com/vagrant/discover)

* note that the BOX name starts with "generic" are publicly & regularly maintained


* Downloaded boxes, by default, will be kept in ~/.vagrant.d/boxes/* and stay there until manually remove.(prefer ```vagrant box remove [BOX_NAME]```)


PROVIDER
    - the real virtualization software like VirtualBox

PROVISION
    - the setup




## Kubernetes Terminology & Basic Knowledge

Cluster
Node
Pods
Control Plane
Agent



* Server needs more than 512MB or RAM
or else it'll froze


## vagrant cache
once run the command ```vagrant up```, the command generated .vagrant/ on the current working directory, and use it to cache the stuff ... sometimes when you change the BOX_NAME and the command still not creating new VM from such BOX, you may need to run this command to clear up the cache:
```rm -rf .vagrant```

## Some useful Vagrant commands


```vagrant init [BOX_NAME]```

Create blank Vagrantfile template from ```BOX_NAME```.

```vagrant status [VM_NAME]```

Show status of the VM (if ```VM_NAME``` is specified) or all of the VMs.

```vagrant halt [VM_NAME]```
Temporary halt (stop - not shutting down) such VM or all if ```VM_NAME``` is not given.


```vagrant box remove [BOX_NAME]```
Remove downloaded box and reclaim back some spaces.

```vagrant up```
Download the boxes and start creating VMs defined in Vagrantfile.

```vagrant destroy [VM_NAME] -f```
Completely remove the VM, ```-f``` option will automatically confirm deletion.

```vagrant ssh [VM_NAME]```
Do the ssh into such VM, this by default will bypass the password since vagrant already keep the SSH keys for all of its VMs.




# Kubernetis / K3S / kubectl


Kubernetes is a container orchestration platform that automates deployment, scaling, networking, and recovery of containerized applications across multiple machines.

K3s is a lightweight version of kubernetis. Make the whole cluster works even on low resources systems like IoT or Edge Computing.

Kubectl is a CLI that can interact with Kubernetis via the Kubernetis exposed API, so you can change the running configuration without retsrating the k8s server


####  
Part 1 - Vagrants & K3s
####  

Setting up VMs from Vagrant and make a simple cluster of K3s Server and Agent







2026-09-10

sudo k3s kubectl apply -f path-to-config.yaml


> sudo -i
change to root so you don't have to sudo every time


sudo k3s kubectl get pods -o wide
sudo k3s kubectl get services
sudo k3s ctr images list



k3s kubectl get deployments




####################### READ HERE 
READ HERE!
####################### READ HERE 


HOST> docker build -t app1 ./

HOST> docker run -p 3001:3000 app1
(test on host machine)

HOST> docker save app1 -o app1.tar
(everything's ok, save the image into the file)



VM> k3s ctr images import app1.tar
// copy and register imported image





--- 
NEEDS CHECKING
---

### choosing the OS
Ubuntu 26.04

"I selected Ubuntu 26.04 LTS as the operating system because it is the latest stable LTS release. The Vagrant box ecosystem is maintained separately from Ubuntu's official releases; Ubuntu does not necessarily publish a Vagrant box for every release. This box is derived from the official Ubuntu cloud image and provides a minimal server environment suitable for IoT development."



## clean up,  
```
vagrant destroy -f
rm -rf .vagrant
vagrant up
```


cirrrr
1. Find box
2. Create VM
3. Configure networking
4. Boot VM
5. Run provisioner  <-- here



# check for IP address
```(vagrant-ssh) > ip a```

```(vagrant-ssh) > ip a show```


```(host machine) > ping 192.168.56.110```


```ssh -i ~/vagrant-test/.vagrant/machines/default/vi
rtualbox/private_key vagrant@192.168.56.110```



Vagrant's provision
processes to do AFTER vagrant create the VM
(the hardware/network was done previously!)


worker.sh

## 
curl -sfL https://get.k3s.io | sh -
## get the K3s instruction and install it




apk add iproute2


k3s
- single binary, under 100MB, used by both server / worker

why k8s?
 mainly about automation for
 - high availibilty
 - scaling
 - scheduling
 - service discovery
 - rolling updates ??? (CI/CD?)
 - resources managment?




k8s terminology

- cluster: a whole kubernetes system (both server and serverWorker)

- node:a machine (could be physical/VM/ cloud VM) that participate in the cluster (could be server/ worker) 


Control Plane vs Worker




Node => abstratcion of machine
it could be either physical , VM or cloud VM

each node provides resources for the pods available in them



So the reason isn't necessarily "my website has lots of visitors."

It's more:

"My application has become a distributed system, and manually managing all these pieces is becoming painful."what about the incoming request





(vm ssh) > sudo ps | grep k3s
check if the k3s service is running?

(vm ssh) > sudo ss -lntp | grep 6443

(if ss is not available)
sudo apk add iproute2




#######################

(server)
sudo k3s kubectl create deployment web --image=nginx



sudo k3s kubectl get pods -o wide



sudo k3s kubectl expose deployment web --port=80










pnamnilS:~$ sudo k3s kubectl get svc web
NAME   TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
web    Cluster




**********************************
sudo k3s kubectl expose deployment web --type=NodePort --name=web-public --port=80


sudo k3s kubectl get svc web-public


sudo k3s kubectl get svc web-public
sudo k3s kubectl get pods -o wide


pnamnilS:~$ sudo k3s kubectl get svc web-public
NAME         TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
web-public   NodePort   10.43.58.227   <none>        80:30570/TCP   115s

pnamnilS:~$ sudo k3s kubectl get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
web-7887448d46-plsf7   1/1     Running   0          8m52s   10.42.0.30   pnamnils   <none>           <none>


pnamnilS:~$ sudo k3s kubectl get endpoints web-public
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME         ENDPOINTS       AGE
web-public   10.42.0.30:80   2m34s
pnamnilS:~$ 


sudo k3s kubectl delete service web-public



sudo k3s kubectl create deployment web --image=nginx



sudo k3s kubectl label node pnamnilsw workload=worker




sudo k3s kubectl get nodes --show-labels



sudo k3s kubectl patch deployment web -p '{"spec":{"template":{"spec":{"nodeSelector":{"workload":"worker"}}}}}'


sudo k3s kubectl taint nodes pnamnils node-role.kubernetes.io/control-plane=true:NoSchedule


sudo k3s kubectl describe node pnamnils



# shell script to install k3s + help
https://get.k3s.io/




k3s default configyuration file 
/etc/rancher/k3s/k3s-agent.env


