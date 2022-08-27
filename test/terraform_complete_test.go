package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCompleteExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/complete",

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
	actualAwsSecurityGroupOtherId := actualTerratest["aws_security_group_other_id"]
	actualAwsEc2ManagedPrefixListOtherId := actualTerratest["aws_ec2_managed_prefix_list_other_id"]
	actualIngress := terraform.Output(t, terraformOptions, "ingress")
	actualEgress := terraform.Output(t, terraformOptions, "egress")
	actualDisabledSgId := terraform.Output(t, terraformOptions, "disabled_sg_id")

	expectedIngress := fmt.Sprintf(
		"[ingress-0-0-all-from-self ingress-0-0-icmp-from-%s ingress-443-443-tcp-from-%s ingress-80-80-tcp-from-%s ingress-all-all-from-10.10.0.0/16,10.20.0.0/24 ingress-postgresql-tcp-from-2001:db8::/64 ingress-ssh-tcp-from-%s]",
		actualDataAwsSecurityGroupDefaultId, actualAwsSecurityGroupOtherId, actualAwsSecurityGroupOtherId, actualDataAwsPrefixListPrivateS3Id,
	)
	expectedEgress := fmt.Sprintf(
		"[egress-0-0-all-to-self egress-0-0-icmp-to-%s egress-443-443-tcp-to-%s egress-80-80-tcp-to-%s egress-all-all-to-public egress-https-443-tcp-to-10.10.0.0/16,10.20.0.0/24 egress-postgresql-tcp-to-2001:db8::/64 egress-ssh-tcp-to-%s]",
		actualDataAwsSecurityGroupDefaultId, actualAwsEc2ManagedPrefixListOtherId, actualAwsEc2ManagedPrefixListOtherId, actualDataAwsPrefixListPrivateS3Id,
	)
	expectedDisabledSgId := "I was not created"

	assert.Equal(t, expectedIngress, actualIngress, "Map %q should match %q", expectedIngress, actualIngress)
	assert.Equal(t, expectedEgress, actualEgress, "Map %q should match %q", expectedEgress, actualEgress)
	assert.Equal(t, expectedDisabledSgId, actualDisabledSgId, "Map %q should match %q", expectedDisabledSgId, actualDisabledSgId)

	terraform.ApplyAndIdempotent(t, terraformOptions)
}
