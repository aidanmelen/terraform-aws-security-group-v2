package test

import (
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
	actualManagedRuleKeys := terraform.Output(t, terraformOptions, "managed_security_group_rule_keys")
	actualRuleKeys := terraform.Output(t, terraformOptions, "security_group_rule_keys")

	expectedManagedRuleKeys := "[ingress-http-80-tcp-from-sg-b551fece]"
	expectedRuleKeys := "[]"

	assert.Equal(t, expectedManagedRuleKeys, actualManagedRuleKeys, "Map %q should match %q", expectedManagedRuleKeys, actualManagedRuleKeys)
	assert.Equal(t, expectedRuleKeys, actualRuleKeys, "Map %q should match %q", expectedRuleKeys, actualRuleKeys)
}
