FROM registry.svc.ci.openshift.org/openshift/release:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/cluster-kube-controller-manager-operator
COPY . .
RUN make build --warn-undefined-variables

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
RUN mkdir -p /usr/share/bootkube/manifests
COPY --from=builder /go/src/github.com/openshift/cluster-kube-controller-manager-operator/bindata/bootkube/* /usr/share/bootkube/manifests/
COPY --from=builder /go/src/github.com/openshift/cluster-kube-controller-manager-operator/cluster-kube-controller-manager-operator /usr/bin/
COPY manifests /manifests
COPY vendor/github.com/openshift/api/operator/v1/0000_25_kube-controller-manager-operator_01_config.crd.yaml /manifests
LABEL io.openshift.release.operator true
