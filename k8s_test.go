package k8s

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	ClusterName    = "test"
	KubeConfigPath = "/home/james/.kube/kind-config-" + ClusterName
	MasterURL      = ""
)

func TestHttpProbeWorks(t *testing.T) {
	cfg, err := clientcmd.BuildConfigFromFlags(MasterURL, KubeConfigPath)
	assert.NoError(t, err)

	cs, err := kubernetes.NewForConfig(cfg)
	assert.NoError(t, err)

	namespace := "sample"
	ns := &corev1.Namespace{
		ObjectMeta: metav1.ObjectMeta{
			// Labels: map[string]string{
			// 	"istio-injection": "enabled",
			// },
			Name: namespace,
		},
	}

	_, err = cs.CoreV1().Namespaces().Create(ns)
	require.NoError(t, err, "create namespace failed")
	// defer cs.CoreV1().Namespaces().Delete(ns.Name, &metav1.DeleteOptions{})

	name := "sample"
	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Labels: map[string]string{
				"app": name,
			},
			Name:      name,
			Namespace: namespace,
		},
		Spec: appsv1.DeploymentSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": name,
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": name,
					},
					Name: name,
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:            name,
							Image:           "nginx:alpine",
							ImagePullPolicy: corev1.PullIfNotPresent,
							Ports: []corev1.ContainerPort{
								{
									ContainerPort: 80,
								},
							},
							ReadinessProbe: &corev1.Probe{
								Handler: corev1.Handler{
									HTTPGet: &corev1.HTTPGetAction{
										Port: intstr.IntOrString{
											IntVal: 80,
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	_, err = cs.AppsV1().Deployments(namespace).Create(deployment)
	require.NoError(t, err, "create deployment failed")

	err = wait.PollImmediate(2*time.Second, 30*time.Second, func() (bool, error) {
		pods, err := cs.CoreV1().Pods(namespace).List(metav1.ListOptions{})

		if err != nil {
			return false, err
		}

		if len(pods.Items) == 0 {
			return false, nil
		}

		for _, pod := range pods.Items {
			ready := false
			for _, c := range pod.Status.Conditions {
				if c.Type == corev1.PodReady && c.Status == corev1.ConditionTrue {
					ready = true
				}
			}

			if !ready {
				return false, nil
			}
		}

		return true, nil
	})
	require.NoError(t, err, "pod(s) not ready")
}
