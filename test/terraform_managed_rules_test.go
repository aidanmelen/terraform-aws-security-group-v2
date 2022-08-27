package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformManagedRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/managed_rules",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualDataAwsSecurityGroupDefaultId := actualTerratest["data_aws_security_group_default_id"]
	actualDataAwsPrefixListPrivateS3Id := actualTerratest["data_aws_prefix_list_private_s3_id"]
	actualIngress := terraform.Output(t, terraformOptions, "ingress")
	actualEgress := terraform.Output(t, terraformOptions, "egress")

	expectedIngress := fmt.Sprintf(
		"[ingress-all-all-from-10.10.0.0/16,10.20.0.0/24 ingress-all-all-from-self ingress-all-icmp-from-%s ingress-postgresql-tcp-from-2001:db8::/64 ingress-ssh-tcp-from-%s]",
		actualDataAwsSecurityGroupDefaultId, actualDataAwsPrefixListPrivateS3Id,
	)
	expectedEgress := fmt.Sprintf(
		"[egress-all-all-to-self egress-all-icmp-to-%s egress-https-443-tcp-to-10.10.0.0/16,10.20.0.0/24 egress-postgresql-tcp-to-2001:db8::/64 egress-ssh-tcp-to-%s]",
		actualDataAwsSecurityGroupDefaultId, actualDataAwsPrefixListPrivateS3Id,
	)

	assert.Equal(t, expectedIngress, actualIngress, "Map %q should match %q", expectedIngress, actualIngress)
	assert.Equal(t, expectedEgress, actualEgress, "Map %q should match %q", expectedEgress, actualEgress)

	terraform.ApplyAndIdempotent(t, terraformOptions)
}
