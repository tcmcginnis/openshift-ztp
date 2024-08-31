 head tomsnotest-ztp.txt 
 git pull
 git rm -r ztp-cluster*/vsphere
 git commit -m "remove cluster" ztp-clusters/vsphere ztp-cluster-applications/vsphere 
 git push
