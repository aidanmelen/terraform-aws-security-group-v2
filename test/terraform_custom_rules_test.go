package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCustomRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/custom_rules",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.
	actualManagedRuleKeys := terraform.Output(t, terraformOptions, "managed_security_group_rule_keys")
	actualRuleKeys := terraform.Output(t, terraformOptions, "security_group_rule_keys")

	expectedManagedRuleKeys := "[]"
	expectedRuleKeys := "[egress-all-all-all-to-self egress-icmp-all-all-to-sg-b551fece egress-tcp-22-22-to-pl-68a54001 egress-tcp-443-443-to-10.10.0.0/16,10.20.0.0/24 egress-tcp-450-350-to-2001:db8::/64 ingress-all-all-all-from-self ingress-icmp-all-all-from-sg-b551fece ingress-tcp-22-22-from-pl-68a54001 ingress-tcp-443-443-from-10.10.0.0/16,10.20.0.0/24 ingress-tcp-450-350-from-2001:db8::/64]"

	assert.Equal(t, expectedManagedRuleKeys, actualManagedRuleKeys, "Map %q should match %q", expectedManagedRuleKeys, actualManagedRuleKeys)
	assert.Equal(t, expectedRuleKeys, actualRuleKeys, "Map %q should match %q", expectedRuleKeys, actualRuleKeys)
}
