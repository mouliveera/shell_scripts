#### Kube Control Manager:
- Continuously looks for pod health status.
- Monitors the state of the system and works towards the bring back to desired state.
Node Controller:
- Every 5s
- Grace peroid 40s

Replication Controller:
- If pod fails, it recreates it.

There are many controllers in kubernetes. All these are bundles with kubernetes control manager.

You can install using kubeadm; It runs as a service on the GKE env.

#### Kube Scheduler:
- Responsible for which pod goes to which node.
- It looks each pod and search for best node where it fits in as per resource requirements
...

#### Kubelet:
- It is like a captain on the ship.
- It interacts with master in a regular interval.
- It in the kubernetes worker node and checks state of the pod and containers then report it to kubeapi server in timely manner.
...

#### Kubeproxy:
- It take care of pod network in different namespaces
- It is process runs on kubernetes nodes and forwards traffic.
- It runs as a deamonset on each node.
...

#### Pod:
- Containers are encapsulated into a k8 object called PODS.
- Its a smallest k8's object you can create in k8.
- It is a single instance of an application.
- Pod can have multiple containers of different kind. Containers shares the same network and storage space.

livenessProbe: Indicates wether the container is running.
readinessProbe: - Indicates whether the container is ready to respond to requests.
                - If the readiness probe fails, the endpoints controller removes the Pod's IP address from the endpoints of all Services that match the Pod
...

#### ReplicaSets: [K8's Controller]
- If app fails and pod gets destroyed, ReplicaSets helps.
- It provides HighAvailability[HA], if existing one fails.
- It helps to share the load. [It scales pods as needed]

*** Replication Controller | ReplicaSets [Both works same]
Replication Controller: Original form of replications in k8s. It is being replaced by replicasets.
- It provides the availability of pods and helps to scale up the number of pods.

ReplicaSets: More or less same as replication controllers. Expect we use `matchLabels` instead of `labels`.

***
The major difference between Replication Controller X ReplicaSets is that the `rolling update`.
Rolling update commands works with Replication controllers, but wont with ReplicaSets. Because ReplicaSets meant to be used as a backend \
for `Deployments`.
***
...

*Deployments: Deployments are intended to replace Replication controllers.
- Rolling Updates helpful during the version upgrades.
- Deployments provides capability to do upgrade underlying pods, seemlessly by rolling upgrade.
...

#### Namespaces:
- K8's supports multiple virtual clusters backed by the same physical cluster.
- These virtual clusters called `namespaces`
- Name of the resource within the namespace should be uniq.
- Namespaces are the way to divide cluster resources between multiple users.
- We can also use labels to distinguish resources within the same namespace.

*** Namespaces provides the isolation.
- Each of namespaces can have different policies.
- We can limit the namespace quota on the cluster.

Namespaces and DNS:
- When you create a service, it creates a corresponding DNS entry. This entry is of the form <service-name>.<namespace>.svc.cluster.local
  svc - subDomain
  Default Domain: cluster.local

*** Low level resources, such as nodes and persistantVolumes, are not in any namespaces.
```bash
# kubectl get namespaces
```
...

#### Services:
- Service is a logical set of Pods.
- Expose an application running on the same set of pods as a network service.
- K8's gives Pods their own IP addresses and a singleDNS name for set of Pods[Service] and can loadbalance across them.
- It enables the communications between group of Pods within and outside of network.

Services Types:
- NodePort #Service accessable on a port on the node [Port range 30000-32767], DefaultPort can be allocated.

- ClusterIP #Service creates a virtual IP with in the cluster.
  - It is a default service type in K8's
  - Service can be accessable from other cluster using the ClusterIP or Service name

- Loadbalancer #Distrubutes the load between the pods under the service.
...

#### Imperative and Declarative:
## Imperative Approach:
- We use kubectl commands to create, update and delete k8's objects.
- Running kubectl commands in k8's is imperative approach.
  Ex: kubectl run nginx --image=nginx #Create a Pod
      kubectl edit po nginx
      kubectl replace -f nginx.yaml

      kubectl create deployment --image=nginx nginx #Deployments create
      kubectl scale deployment nginx --replicas=4

      kubectl expose pod redis --port=6379 --name redis-service --dry-run -o yaml
      kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml
      kubectl create service clusterip redis --tcp=6379:6379 --dry-run -o yaml
- This approach helpful to create k8's objects quickly.

## Declarative Approach:
- kubectl apply commands are intelligent enough to handle K8's objects
   Ex:
   kubectl apply -f nginx.yaml
   kubectl apply -f /path/to/config-files

...
#### Scheduling a pod on a Node
- We can create a Pod with manual scheduling.
  Use `# nodeName:` entry in pod manifest file to specify in which Node the Pod has to be deployed.

...

## K8's objects use different labels and selectors to group and select the different resources.
## Annotations: They are used to record the details for informative purpose.

#### Taints and Tolerations

- Nothing to do with security or intorsions
- They used to set instructions to node the pods can be created.
- Taints can set on Nodes and Tolerations can set on Pods.
- There are 3 taint effects
1. NoSchedule - Pods will not schedule
2. PreferNoSchedule - System try to avoid.
3. NoExecute - New pods will not schedule. And existing pods may evicted if they dont tolarate the taints.


## Use case:
```bash
I see some blocks with one of pods[r4e-elasticsearch-legacy-cluster-master-1] in statefulsets r4e-elasticsearch-legacy-cluster-master. It is not moving to another node in GKE pool after killing the pod, and pod experiencing memory issues on that node[gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-jgp9]. Tried killing couple of times[Most of us do the same to avoid the memory issues for pods], but no luck in this case.
To move that pod to another node. I just added a taint on that node, so that no pods can schedule on that node.
ke2e taint nodes gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-jgp9 value:NoSchedule
Killed the r4e-elasticsearch-legacy-cluster-master-1 to recreate on another node. Later i removed the taints on node gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-jgp9 to free up.
ke2e taint nodes gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-jgp9 value:NoSchedule-
ES Legacy cluster is healthy now:
r4e-elasticsearch-legacy-cluster-master-0           2/2     Running             0          3d7h    10.236.0.6      gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-uqn7   <none>           <none>
r4e-elasticsearch-legacy-cluster-master-1           2/2     Running             0          3m39s   10.236.6.31     gke-k8s-e2e-primary-n2-highmem-4-node-edb1954a-rwmw   <none>           <none>
r4e-elasticsearch-legacy-cluster-master-2           2/2     Running             0          129m    10.236.8.110    gke-k8s-e2e-primary-n2-highmem-4-node-e12cb158-psuo   <none>           <none>
Ref doc: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
```


#### Node Selectors
- We can set limitations on PODS in pod definition files.
- How to add a label to a nodes
  ```
  kubectl label nodes <node-name> <label-key>=<label-value>
  ```
- We can add complex limitations with NodeSelectors.
Ex: If we 3 different kind of nodes with labels Large, Medium and small.
We can write a condition in pod definition file to restrict pod to place large or small or medium nodes.
We can not restrict a pod with multiple or complex conditions here, like not small , it can be placed in any of medium or large nodes.

This can be achieved in NodeAffinity.

#### Node Affinity
- This feature provides advanced limitations
- Types
  - requiredDuringSchedulingIgnoredSuringExecution
  - preferredDuringSchedulingIgnoredSuringExecution
  - requiredDuringSchedulingRequiredSuringExecution

NOTE:
```
- Taints and Tolarations are not garentied that pods only goes to tainted nodes.
- Node Affinity: labeled pods may go to different Nodes.

We can achieve that pod goes to specific node by using both taintTolarations and NodeAffinity.
```

#### Resources and limits
- KubeSchedular will take care of pod resources depends on node resource availability.
- Define resource requests and limits in pod definition file.
- By default k8's provides 0.5 CPU and 256Mi Memory. You can get the limits details by running `kubectl get limitRange -A`

1G (Gigabyte) = 1000 X 1000 X 1000 = 1000000000 bytes
1M (Megabyte) = 1000 X 1000 = 1000000 bytes
1K (Kilobyte) = 1000 bytes

1Gi (Gibibyte) = 1024 X 1024 X 1024 = 1073741824 bytes
1Mi (Mebibyte) = 1024 X 1024 = 1048576 bytes
1Ki (Kibibyte) = 1024 bytes

- If pod try to use more resources than the limits set, pod will crash.

#### DaemonSets
- These are like replicaSets.
- These ensures one copy of the daemonSet pods on each nodes.
- Ex: Kube-proxy can be deployed as DaemonSets.

#### StaticPods
- All nodes installed with kubelet. We can create a=staticPods on nodes.
- Only pods can be created in this way. Create a directory /etc/kubernetes/manifests and let kubelet to check the directory periodically.
- You need to instruct kubelet in config files to read those manifests.

#### ConfigMaps
- Used to pass configuration data using key value pairs.
- Its a plain text format.

#### Secrets
- K8's use it for sensitive data in encoded/hash format.
```
kubectl create secret generic <secret-name> --from-literal=<key>=<value>

Ex:
kubectl create secret generic \
   xyz-service-secrets --from-literal=DB_Host=mysql --from-literal=DB_password=password
```

You can use a file option as well.
```
 kubectl create secret generic \
   app-secrets --from-file=secret.properties
```
Ingecting secrets as Environmnet variables to pods:
You can specify it in spec section with `envFrom.secretRef.name` in pod definition file.

Secret as volume: we can keep the files in directory and mount them as volumes on the pods.
Ref:
Create secrets and then apply/inject them to pods.
1. Create secret:
```
k create secret generic test-secret --from-literal=username=user1 --from-literal=password=password1 --dry-run -o yaml > secret-def.yaml
```
Apply the above yaml file to create secrets.

2. Ingect them with a pod as volumeMounts.
```
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-mount
  labels:
    name: test-pod
spec:
  containers:
  - name: busybox
    image: mongo
    volumeMounts:
      - name: dbuser
        mountPath: "/etc/mongo/secrets"
        readOnly: true
  volumes:
  - name: dbuser
    secret:
      secretName: test-secret
```

#### Multi container Pods
- SideCar
- Adapter
- Ambassador

## InitContainers
- init containers: specialized containers that run before app containers in a Pod
- Init containers can contain utilities or setup scripts not present in an app image.
- An initContainer is configured in a pod like all other containers, except that it is specified inside a initContainers section
- When a POD is first created the initContainer is run, and the process in the initContainer must run to a completion before the real container hosting the application starts.


#### OS version upgrades
kubectl get nodes > Lists nodes and its versions
kubectl drain nodeName > Drain node
kubectl cordon nodeName > To make the node unschedulable
kubectl uncordon nodeName > To make the node schedulable

#### Backup and Restore methods in K8's
We know that the ETCD stores all the cluster related information.

- VELERO - Tool to take the backup of kubernetes objects
  Ex: kubectl get all -A -o yaml > all-deployment-service.yaml

ETCD: It save the state of kubernetes cluster. Nodes and other resources info.
      - Its a key-value store of the k8's cluster.
      - It is configured on master node.
      - It comes with build in snapshot features.
      - etcdctl commands useful to take snapshot and restore k8's cluster.
      - To make use of etcdctl for tasks such as back up and restore, make sure that you set the ETCDCTL_API to 3.
      - export ETCDCTL_API=3 > on master node.

Useful doc: https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster


## Security:
- All pods in the cluster can communicate each other. It can be restricted using network policies.

#### Authentication:
- Who can access the cluster.
- Kubeapiserver Authenticate before processing the requests.

#### Authorisation:
- What they can do.
- RBAC and Service accounts used for authorisation.


#### TLS Certificates
- SSL and TLS Certificates.
- SYMMETRIC ENCRYPTION: If the same key is used for encription and decription in estabilishing a secure connection.
- ASYMMETRIC: It uses a private key and public lock
- In Web server world we use openssl to create public key and private lock files for secure connection.
- The whole infra of creating SSL/TSL keys, distributing the digital certs is known as PKI[Public Key Infrastructure]

#### Securing K8's with SSL Certificates:
- Server Certificates[Configured on servers]
- Root Certificates[Configured on CertificateAuthority Servers]
- Client Certificates[Configured on client side]

K8's having master and worker nodes, they communicate with in the clusters securily with TLS Certificates.
- Kubeapiserver server uses https secure connections between the worker nodes.

- Kube-API server communicates with ETCD server when it is accessed by other servers like kube scheduler, kube controller and kube proxy.

####


## Storage
- Docker stores files in /var/lib/docker [aufs,containers,image,volumes]
- there are 2 types of mountings 1. volumes and 2.Bind mounting.

> docker volume create data_volume #Create a volume
> docker run -v data_volume:/var/lib/mysql mysql #To mount that volume on a containers [Volume mounting]
> docker run -v /data/mysql:/var/lib/mysql mysql #To mount external volumes on a container [Bind mounting]

> docker run mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql #Instead of 'v' option we can use mount options.

#### Container storage information:
Volume Types:
hostPath - Volume on a node, it is best fit for single node cluster.

We can use NFS, google persistance disks or many.
If we want to use EBS volume as volume, we can replace the hostPath here.
```bash
Ex:
volumes:
- name: data-volume
  awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4
```

Large pool of storage and user can use the piece of it, that called PVC(PersistanceVolumeClaim)

Create a Persistent Volume:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
      storage: 10Gi
  hostPath:
    path: /tmp/data
```

hostpath can be replaced with EBS like we mentioned in previous notes:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
      storage: 10Gi
  awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4
```

## PersistanceVolumeClaim[PVC]
- PV and PVC are 2 different objects.
- PV - An admin creates it and user creates PVCs.
- K8's binds PVC to respective objects
- If the PV is not available to bound for a PVC, it remain in a pending state and waits for it.

```
apiVersion: v1
kind: PersistanceVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
Ex:
```
root@controlplane:~# cat pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-pvc
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi

Q2:Create a new pod called nginx with the image nginx:alpine. The Pod should make use of the PVC local-pvc and mount the volume at the path /var/www/html.The PV local-pv should in a bound state.
----
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  volumes:
    - name: nginx-volume
      persistentVolumeClaim:
        claimName: local-pvc
  containers:
    - name: nginx
      image: nginx:alpine
      volumeMounts:
        - mountPath: "/var/www/html"
          name: nginx-volume
----
Q3:Create a new Storage Class called delayed-volume-sc that makes use of the below specs:

provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

Storage Class uses: kubernetes.io/no-provisioner ?
Storage Class volumeBindingMode set to WaitForFirstConsumer ?
Ans:
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: delayed-volume-sc
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
----
```
kubectl get PersistanceVolumeClaim # to list the PVC's

- What happens to volume[PV], when the PVC is deleted. We can set different policies on PV.
- Default policy is `PersistanceVolumeReclaimPolicy: Retain` -> It is manually deleted by admin.
- PersistanceVolumeReclaimPolicy: Delete -> Once claim is deleted volume will be deleted.
- PersistanceVolumeReclaimPolicy: Recycle -> Data will be removed, to available for other claims.

Storage Class:
Static provisioning:
- Before we create PV and PVC, we need to manually create disks on GoogleCloud or aws.

It would be nice to create disks when ever application requires it, that where storage classes come in.


Dynamic provisioning: known as storageClass:
```
apiVersion: storage.k8s.io/v1
kind: storageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/gce-pd
```
Storage class creates the PV's on GoogleCloud with out manual efforts of creating disks.

## Networking[kubelet will takes care of network for Containers]
#### Network namespaces:
- Containers are separated by logical namespaces.

CNI: Container network interface - Installed on each node to provide better communications.




## Ingress

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster.

Client -> Ingress-managed Loadbalancer -> Ingress -> Route rules -> Service -> PODS











NOTE:
kubectl explain <RESOURCE> --recursive #Shows the pod definitions
❯ k explain pod --recursive







Notes:
Continuous Integration:





SKIPPED: 144-166[Please refer]
