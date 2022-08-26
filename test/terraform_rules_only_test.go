package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformRulesOnlyExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/rules_only",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.
	actualDataAwsSecurityGroupDefaultId := terraform.Output(t, terraformOptions, "data_aws_security_group_default_id")
	actualIngress := terraform.Output(t, terraformOptions, "ingress_keys")
	actualEgress := terraform.Output(t, terraformOptions, "egress_keys")

	expectedIngress := fmt.Sprintf("[ingress-http-80-tcp-from-%s]", actualDataAwsSecurityGroupDefaultId)
	expectedEgress := "[]"

	assert.Equal(t, expectedIngress, actualIngress, "Map %q should match %q", expectedIngress, actualIngress)
	assert.Equal(t, expectedEgress, actualEgress, "Map %q should match %q", expectedEgress, actualEgress)
}
