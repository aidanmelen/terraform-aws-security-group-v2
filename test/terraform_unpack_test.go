package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformUnpackRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/unpack",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.

	// assign actual
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualIngressCount := actualTerratest["ingress_count"]
	actualEgressCount := actualTerratest["egress_count"]

	// assign expected
	expectedIngressCount := "29"
	expectedEgressCount := "0"

	// assert
	assert.Equal(t, expectedIngressCount, actualIngressCount, "Map %q should match %q", expectedIngressCount, actualIngressCount)
	assert.Equal(t, expectedEgressCount, actualEgressCount, "Map %q should match %q", expectedEgressCount, actualEgressCount)
}
