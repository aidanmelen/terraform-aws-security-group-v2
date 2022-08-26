package test

import (
	"fmt"
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
	actualDataAwsSecurityGroupDefaultId := terraform.Output(t, terraformOptions, "data_aws_security_group_default_id")
	actualDataAwsPrefixListPrivateS3Id := terraform.Output(t, terraformOptions, "data_aws_prefix_list_private_s3_id")
	actualIngress := terraform.Output(t, terraformOptions, "ingress_keys")
	actualEgress := terraform.Output(t, terraformOptions, "egress_keys")

	expectedIngress := fmt.Sprintf(
		"[ingress-22-22-tcp-from-%s ingress-443-443-tcp-from-10.10.0.0/16,10.20.0.0/24 ingress-450-350-tcp-from-2001:db8::/64 ingress-all-all-all-from-self ingress-all-all-icmp-from-%s]",
		actualDataAwsPrefixListPrivateS3Id, actualDataAwsSecurityGroupDefaultId,
	)
	expectedEgress := fmt.Sprintf(
		"[egress-22-22-tcp-to-%s egress-443-443-tcp-to-10.10.0.0/16,10.20.0.0/24 egress-450-350-tcp-to-2001:db8::/64 egress-all-all-all-to-self egress-all-all-icmp-to-%s]",
		actualDataAwsPrefixListPrivateS3Id, actualDataAwsSecurityGroupDefaultId,
	)

	assert.Equal(t, expectedIngress, actualIngress, "Map %q should match %q", expectedIngress, actualIngress)
	assert.Equal(t, expectedEgress, actualEgress, "Map %q should match %q", expectedEgress, actualEgress)
}
