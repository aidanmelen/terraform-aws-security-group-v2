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
	actualIngressRuleKeys := terraform.Output(t, terraformOptions, "ingress_rule_keys")
	actualManagedIngressRuleKeys := terraform.Output(t, terraformOptions, "managed_ingress_rule_keys")
	actualEgressRuleKeys := terraform.Output(t, terraformOptions, "egress_rule_keys")
	actualManagedEgressRuleKeys := terraform.Output(t, terraformOptions, "managed_egress_rule_keys")

	expectedIngressRuleKeys := "[]"
	expectedEgressRuleKeys := "["
	expectedManagedIngressRuleKeys := "[ingress-all-all-from-self ingress-https-tcp-from-10.0.0.0/24]"
	expectedManagedEgressRuleKeys := "[egress-all-all-to-0.0.0.0/0 egress-all-all-to-::/0]"

	assert.Equal(t, expectedIngressRuleKeys, actualIngressRuleKeys, "Map %q should match %q", expectedIngressRuleKeys, actualIngressRuleKeys)
	assert.Equal(t, expectedManagedIngressRuleKeys, actualManagedIngressRuleKeys, "Map %q should match %q", expectedManagedIngressRuleKeys, actualManagedIngressRuleKeys)
	assert.Equal(t, expectedEgressRuleKeys, actualEgressRuleKeys, "Map %q should match %q", expectedEgressRuleKeys, actualEgressRuleKeys)
	assert.Equal(t, expectedManagedEgressRuleKeys, actualManagedEgressRuleKeys, "Map %q should match %q", expectedManagedEgressRuleKeys, actualManagedEgressRuleKeys)
}
