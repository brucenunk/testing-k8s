package k8s

import (
	"testing"
	"time"
)

const (
	Namespace = "test"
	Timeout   = 30 * time.Second
)

func TestHttpProbeWorks(t *testing.T) {
	k8s := newK8s(t)
	nginx := nginx(Namespace, "sample")

	k8s.createNamespace(Namespace)
	k8s.createDeployment(nginx)
	k8s.waitForPodsReady(Namespace, Timeout)
}
