package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformBasicExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/basic",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.
	actualIngressKeys := terraform.Output(t, terraformOptions, "ingress_keys")
	actualEgressKeys := terraform.Output(t, terraformOptions, "egress_keys")

	expectedIngressKeys := "[ingress-all-all-from-self ingress-https-443-tcp-from-10.0.0.0/24]"
	expectedEgressKeys := "[egress-all-all-to-public]"

	assert.Equal(t, expectedIngressKeys, actualIngressKeys, "Map %q should match %q", expectedIngressKeys, actualIngressKeys)
	assert.Equal(t, expectedEgressKeys, actualEgressKeys, "Map %q should match %q", expectedEgressKeys, actualEgressKeys)

	terraform.ApplyAndIdempotent(t, terraformOptions)
}