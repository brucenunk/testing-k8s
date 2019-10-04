package k8s

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	ClusterName    = "test"
	KubeConfigPath = "/home/james/.kube/kind-config-" + ClusterName
	MasterURL      = ""
)

func TestListNodes(t *testing.T) {
	cfg, err := clientcmd.BuildConfigFromFlags(MasterURL, KubeConfigPath)
	assert.NoError(t, err)

	cs, err := kubernetes.NewForConfig(cfg)
	assert.NoError(t, err)

	ns, err := cs.CoreV1().Nodes().List(metav1.ListOptions{})
	assert.NoError(t, err)

	for _, n := range ns.Items {
		fmt.Printf("name=%v\n", n.ObjectMeta.Name)
	}
}
