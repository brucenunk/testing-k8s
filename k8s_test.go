package k8s

import (
	"testing"
	"time"
)

const (
	ClusterName    = "test"
	KubeConfigPath = "/home/james/.kube/kind-config-" + ClusterName
	Namespace      = "test"
	Timeout        = 30 * time.Second
)

func TestHttpProbeWorks(t *testing.T) {
	k8s := newK8s(t, KubeConfigPath)
	nginx := nginx(Namespace, "sample")

	k8s.createNamespace(Namespace)
	k8s.createDeployment(nginx)
	k8s.waitForPodsReady(Namespace, Timeout)
}
