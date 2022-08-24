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
	actualIngressRuleKeys := terraform.Output(t, terraformOptions, "ingress_rule_keys")
	actualManagedIngressRuleKeys := terraform.Output(t, terraformOptions, "managed_ingress_rule_keys")
	actualEgressRuleKeys := terraform.Output(t, terraformOptions, "egress_rule_keys")
	actualManagedEgressRuleKeys := terraform.Output(t, terraformOptions, "managed_egress_rule_keys")
	actualComputedIngressRuleLength := len(terraform.OutputList(t, terraformOptions, "computed_egress_rule_ids"))
	actualComputedEgressRuleLength := len(terraform.OutputList(t, terraformOptions, "computed_ingress_rule_ids"))
	actualComputedManagedIngressRuleLength := len(terraform.OutputList(t, terraformOptions, "computed_managed_egress_rule_ids"))
	actualComputedManagedEgressRuleLength := len(terraform.OutputList(t, terraformOptions, "computed_managed_ingress_rule_ids"))
	actualAutoGroupIngressAllFromSelfRuleKeys := terraform.Output(t, terraformOptions, "auto_group_ingress_all_from_self_rule_keys")
	actualAutoGroupEgressAllToPublicInternetRuleKeys := terraform.Output(t, terraformOptions, "auto_group_egress_all_to_public_internet_rule_keys")

	expectedIngressRuleKeys := "[]"
	expectedManagedIngressRuleKeys := "[ingress-http-80-tcp-from-sg-b551fece]"
	expectedEgressRuleKeys := "[]"
	expectedManagedEgressRuleKeys := "[]"
	expectedComputedIngressRuleLength := 0
	expectedComputedEgressRuleLength := 0
	expectedComputedManagedIngressRuleLength := 0
	expectedComputedManagedEgressRuleLength := 0
	expectedAutoGroupIngressAllFromSelfRuleKeys := "[]"
	expectedAutoGroupEgressAllToPublicInternetRuleKeys := "[]"

	assert.Equal(t, expectedIngressRuleKeys, actualIngressRuleKeys, "Map %q should match %q", expectedIngressRuleKeys, actualIngressRuleKeys)
	assert.Equal(t, expectedManagedIngressRuleKeys, actualManagedIngressRuleKeys, "Map %q should match %q", expectedManagedIngressRuleKeys, actualManagedIngressRuleKeys)
	assert.Equal(t, expectedEgressRuleKeys, actualEgressRuleKeys, "Map %q should match %q", expectedEgressRuleKeys, actualEgressRuleKeys)
	assert.Equal(t, expectedManagedEgressRuleKeys, actualManagedEgressRuleKeys, "Map %q should match %q", expectedManagedEgressRuleKeys, actualManagedEgressRuleKeys)
	assert.Equal(t, expectedComputedIngressRuleLength, actualComputedIngressRuleLength, "Map %q should match %q", expectedComputedIngressRuleLength, actualComputedIngressRuleLength)
	assert.Equal(t, expectedComputedEgressRuleLength, actualComputedEgressRuleLength, "Map %q should match %q", expectedComputedEgressRuleLength, actualComputedEgressRuleLength)
	assert.Equal(t, expectedComputedManagedIngressRuleLength, actualComputedManagedIngressRuleLength, "Map %q should match %q", expectedComputedManagedIngressRuleLength, actualComputedManagedIngressRuleLength)
	assert.Equal(t, expectedComputedManagedEgressRuleLength, actualComputedManagedEgressRuleLength, "Map %q should match %q", expectedComputedManagedEgressRuleLength, actualComputedManagedEgressRuleLength)
	assert.Equal(t, expectedAutoGroupIngressAllFromSelfRuleKeys, actualAutoGroupIngressAllFromSelfRuleKeys, "Map %q should match %q", expectedAutoGroupIngressAllFromSelfRuleKeys, actualAutoGroupIngressAllFromSelfRuleKeys)
	assert.Equal(t, expectedAutoGroupEgressAllToPublicInternetRuleKeys, actualAutoGroupEgressAllToPublicInternetRuleKeys, "Map %q should match %q", expectedAutoGroupEgressAllToPublicInternetRuleKeys, actualAutoGroupEgressAllToPublicInternetRuleKeys)
}
