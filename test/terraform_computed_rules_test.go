package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformComputedRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/computed_rules",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualAwsSecurityGroupOtherId := actualTerratest["aws_security_group_other_id"]
	actualAwsEc2ManagedPrefixListOtherId := actualTerratest["aws_ec2_managed_prefix_list_other_id"]
	actualIngressKeys := terraform.Output(t, terraformOptions, "ingress_keys")
	actualEgressKeys := terraform.Output(t, terraformOptions, "egress_keys")

	expectedIngressKeys := fmt.Sprintf("[ingress-443-443-tcp-from-%s ingress-80-80-tcp-from-%s]", actualAwsSecurityGroupOtherId, actualAwsSecurityGroupOtherId)
	expectedEgressKeys := fmt.Sprintf("[egress-443-443-tcp-to-%s egress-80-80-tcp-to-%s]", actualAwsEc2ManagedPrefixListOtherId, actualAwsEc2ManagedPrefixListOtherId)

	assert.Equal(t, expectedIngressKeys, actualIngressKeys, "Map %q should match %q", expectedIngressKeys, actualIngressKeys)
	assert.Equal(t, expectedEgressKeys, actualEgressKeys, "Map %q should match %q", expectedEgressKeys, actualEgressKeys)

	terraform.ApplyAndIdempotent(t, terraformOptions)
}