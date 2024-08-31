for i in $(oc get no|grep worker|awk '{print $1}'|xargs echo)
do
  scp -p /root/aap2-subscription-manifest.zip /root/rh-ocp-pull-secret.json core@$i:
  ssh core@$i 'sudo mkdir /var/lib/secrets; sudo mv ~core/aap2-subscription-manifest.zip ~core/rh-ocp-pull-secret.json /var/lib/secrets/'
  ssh core@$i 'sudo chmod 755 /var/lib/secrets; chod 644 /var/lib/secrets/aap2-subscription-manifest.zip /var/lib/secrets/rh-ocp-pull-secret.json'
  #ssh core@$i 'sudo mkdir /tmp/ztp; sudo mv ~core/aap2-subscription-manifest.zip ~core/rh-ocp-pull-secret.json /tmp/ztp'
  #ssh core@$i 'sudo chmod 666 /tmp/ztp/aap2-subscription-manifest.zip /tmp/ztp/rh-ocp-pull-secret.json'
done

