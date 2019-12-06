package k8s

import (
	"testing"
	"time"
)

const (
	Namespace = "test"
	Timeout   = 2 * time.Minute
)

func TestHttpProbeWorks(t *testing.T) {
	k8s := newK8s(t)

	k8s.createNamespace(Namespace)
	defer k8s.deleteNamespace(Namespace)

	k8s.createDeployment(nginx(Namespace, "sample"))
	k8s.waitForPodsReady(Namespace, Timeout)
}
