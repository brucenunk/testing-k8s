package k8s

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"sigs.k8s.io/kind/pkg/cluster"
)

func TestSpinUpCluster(t *testing.T) {
	ctx := cluster.NewContext("test")
	defer ctx.Delete()

	err := ctx.Create()
	assert.NoError(t, err)
}
