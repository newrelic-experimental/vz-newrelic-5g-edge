# Installing Pixie and New Relic in an EKS Wavelength cluster

- If you have a New Relic account already, proceed to the [New Relic Guided Install]() section below.
- If you don't have a New Relic account but want one, you can [sign up for our Free Tier](https://newrelic.com/signup) (100GB data per month).
- If you'd prefer to install Pixie Open Source, proceed to the [Pixie Open Source]() section.

## New Relic Guided Install

New Relic's Guided Install for Kubernetes provides multiple options for installing both New Relic and Pixie components into your cluster.  The example below is a modified version of the Helm 3 install provided by our Guided Install UI.  See New Relic's [helm charts](https://github.com/newrelic/helm-charts) for more info on individual chart details.

Note that the following components are `disabled` in this example:

- New Relic Prometheus OpenMetrics Integration
- New Relic Logging Integration (Fluent-Bit)

The following components will be installed:

- Kube State Metrics
- New Relic Infrastructure
- New Relic Kubernetes Events Integration
- Pixie

NOTE: Pixie currently requires 2GB memory minimum per cluster node.  Please see the [Pixie requirements documentation](https://docs.px.dev/installing-pixie/requirements/) for more info.

To obtain the necessary New Relice License, Pixie API and Deploy keys, visit the [Guided Install](https://one.newrelic.com/nr1-core?state=c6cc92c6-1579-c708-96c0-98dc5082c4e2).

```
kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/px.dev_viziers.yaml && \
kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/olm_crd.yaml && \
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=<NEW RELIC LICENSE KEY> \
 --set global.cluster=wavelength-test \
 --namespace=newrelic \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set ksm.enabled=true \
 --set prometheus.enabled=false \
 --set kubeEvents.enabled=true \
 --set logging.enabled=false \
 --set newrelic-pixie.enabled=true \
 --set newrelic-pixie.apiKey=<PIXIE API KEY> \
 --set pixie-chart.enabled=true \
 --set pixie-chart.deployKey=<PIXIE DEPLOY KEY> \
 --set pixie-chart.clusterName=wavelength-test
```

## Patching Components for EKS Wavelength

### Patching CoreDNS

EKS cluster nodes in separate Wavelength zones (e.g. `us-east-1-wl1-bos-wlz-1` and `us-east-1-wl1-nyc-wlz-1`) are not able to communicate with one another directly by default. To ensure DNS queries did not fail, we patched the CoreDNS deployment so it would run in the parent region (`us-east-1`). The cluster nodes in the Wavelength zones are able to communicate back to the nodes in the parent region.  Please see [AWS Wavelength Considerations and Quotas](https://docs.aws.amazon.com/wavelength/latest/developerguide/wavelength-quotas.html) for more info.

```
kubectl patch deployments coredns -n kube-system -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
```

### Patching Pixie

Only the `vizier-pem` Daemonset pods should be running on the Wavelength cluster nodes.  All other Pixie components need to run on nodes in the parent region as they need to be reachable from all Wavelength nodes.

```
kubectl patch statefulsets pl-nats -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch statefulsets vizier-metadata -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments catalog-operator -n olm -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments olm-operator -n olm -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments vizier-operator -n px-operator -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments kelvin -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments vizier-certmgr -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments vizier-cloud-connector -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments vizier-proxy -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
kubectl patch deployments vizier-query-broker -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
```

### Patching Kube State Metrics

Kube State Metrics must also reside on one of the cluster nodes in the parent region so that it's accessible by the New Relic Infrastructure agent running on the Wavelength nodes.

```
kubectl patch deployments newrelic-bundle-kube-state-metrics -n newrelic -p '{"spec": {"template": {"spec": {"nodeSelector": {"pixie.io/components": "true"}}}}}'
```

## Pixie Open Source Install

Coming soon...