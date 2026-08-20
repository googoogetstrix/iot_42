portable vagrant binary [Official hashiCorp DL page](https://developer.hashicorp.com/vagrant/install)


1.) download and extract to your ```~/bin``` directory (create if you don't have one)

2.) add the path to your own bin into ```~/.zshrc```

```export PATH="$HOME/bin:$PATH"```

restrat the terminal or ```source ~/.zshrc```



3.) setting up the test VM
```mkdir ~/vagrant-test```
```cd ~/vagrant-test```
```vagrant init hashicorp/bionic64```

the ```hashicorp/bionic64``` is a box name (somewhat like Docker's image name)




vagrant is directory based, you have to cd into where the Vagrantfile is before running the vagrant commands (like status , up , halt)


### create the default Vagrantfile template
```vagrant init BOX_NAME```

[HashiCorp Discover Vagrant Boxes] (https://portal.cloud.hashicorp.com/vagrant/discover)


note that the BOX name starts with "generic" are publicly & regularly maintain


### check if any VM is running under vagrant
```vagrant status```

### temporary stop the VM
```vagrant halt```

### destroy the VM and it's content
```vagrant destroy -f```
```vagrant ssh```


# use this command to inspect the disk usage
```du -sh ~/.vagrant.d/boxes/*```

# to remove the bixes, use this command instead
```vagrant box remove hashicorp/bionic64```


### VM is always there unless you halt or remove them!




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