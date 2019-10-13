package k8s

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	masterURL = ""
)

type k8s struct {
	cs *kubernetes.Clientset
	t  *testing.T
}

/// newK8s
func newK8s(t *testing.T, kubeConfigPath string) k8s {
	cfg, err := clientcmd.BuildConfigFromFlags(masterURL, kubeConfigPath)
	require.NoError(t, err)

	cs, err := kubernetes.NewForConfig(cfg)
	require.NoError(t, err)

	return k8s{
		cs: cs,
		t:  t,
	}
}

/// createDeployment
func (k k8s) createDeployment(deployment *appsv1.Deployment) {
	_, err := k.cs.AppsV1().Deployments(deployment.ObjectMeta.Namespace).Create(deployment)
	require.NoError(k.t, err, "create deployment failed")
}

/// createNamespace
func (k k8s) createNamespace(name string) {
	ns := &corev1.Namespace{
		ObjectMeta: metav1.ObjectMeta{
			// Labels: map[string]string{
			// 	"istio-injection": "enabled",
			// },
			Name: name,
		},
	}

	_, err := k.cs.CoreV1().Namespaces().Create(ns)
	require.NoError(k.t, err, "create namespace failed")
}

/// listPodsE
func (k k8s) listPodsE(namespace string) (*corev1.PodList, error) {
	return k.cs.CoreV1().Pods(namespace).List(metav1.ListOptions{})
}

/// waitForPodsReady
func (k k8s) waitForPodsReady(namespace string, timeout time.Duration) {
	err := wait.PollImmediate(1*time.Second, timeout, func() (bool, error) {
		pods, err := k.listPodsE(namespace)

		if err != nil {
			return false, err
		}

		for _, pod := range pods.Items {
			if !isPodReady(pod) {
				return false, nil
			}
		}

		return len(pods.Items) > 0, nil
	})

	require.NoError(k.t, err, "pod(s) not ready")
}

/// isPodReady
func isPodReady(pod corev1.Pod) bool {
	ready := false

	for _, c := range pod.Status.Conditions {
		if c.Type == corev1.PodReady && c.Status == corev1.ConditionTrue {
			ready = true
		}
	}

	return ready
}
