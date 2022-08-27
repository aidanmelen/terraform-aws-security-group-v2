package test

import (
	"fmt"
	"regexp"
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

	// assign actual
	actualSecurityGroupId := terraform.Output(t, terraformOptions, "id")
	actualIngress := terraform.OutputList(t, terraformOptions, "ingress")
	actualEgress := terraform.OutputList(t, terraformOptions, "egress")
	regexp, _ := regexp.Compile(`sgrule-[a-z0-9]*`)
	actualIngress0 := regexp.ReplaceAllString(actualIngress[0], "sgrule-1111111111")
	actualIngress1 := regexp.ReplaceAllString(actualIngress[1], "sgrule-1111111111")
	actualIngress2 := regexp.ReplaceAllString(actualIngress[2], "sgrule-1111111111")
	actualIngress3 := regexp.ReplaceAllString(actualIngress[3], "sgrule-1111111111")
	actualIngress4 := regexp.ReplaceAllString(actualIngress[4], "sgrule-1111111111")
	actualIngress5 := regexp.ReplaceAllString(actualIngress[5], "sgrule-1111111111")
	actualIngress6 := regexp.ReplaceAllString(actualIngress[6], "sgrule-1111111111")
	actualIngress7 := regexp.ReplaceAllString(actualIngress[7], "sgrule-1111111111")
	actualIngress8 := regexp.ReplaceAllString(actualIngress[8], "sgrule-1111111111")
	actualEgress0 := regexp.ReplaceAllString(actualEgress[0], "sgrule-1111111111")
	actualEgress1 := regexp.ReplaceAllString(actualEgress[1], "sgrule-1111111111")
	actualEgress2 := regexp.ReplaceAllString(actualEgress[2], "sgrule-1111111111")
	actualEgress3 := regexp.ReplaceAllString(actualEgress[3], "sgrule-1111111111")
	actualEgress4 := regexp.ReplaceAllString(actualEgress[4], "sgrule-1111111111")
	actualEgress5 := regexp.ReplaceAllString(actualEgress[5], "sgrule-1111111111")
	actualEgress6 := regexp.ReplaceAllString(actualEgress[6], "sgrule-1111111111")
	actualDisabledSgId := terraform.Output(t, terraformOptions, "disabled_sg_id")
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualDataAwsSecurityGroupDefaultId := actualTerratest["data_aws_security_group_default_id"]
	actualDataAwsPrefixListPrivateS3Id := actualTerratest["data_aws_prefix_list_private_s3_id"]
	actualAwsSecurityGroupOtherId := actualTerratest["aws_security_group_other_id"]
	actualAwsEc2ManagedPrefixListOtherId := actualTerratest["aws_ec2_managed_prefix_list_other_id"]

	// assign expected
	expectedIngress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:icmp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:0 type:ingress]", actualSecurityGroupId, actualDataAwsSecurityGroupDefaultId)
	expectedIngress1 := fmt.Sprintf("map[cidr_blocks:[10.10.0.0/16 10.20.0.0/24] description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:0 type:ingress]", actualSecurityGroupId)
	expectedIngress2 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:[2001:db8::/64] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:5432 type:ingress]", actualSecurityGroupId)
	expectedIngress3 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:0 type:ingress]", actualSecurityGroupId)
	expectedIngress4 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:80 type:ingress]", actualSecurityGroupId)
	expectedIngress5 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:ingress]", actualSecurityGroupId)
	expectedIngress6 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:22 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:22 type:ingress]", actualDataAwsPrefixListPrivateS3Id, actualSecurityGroupId)
	expectedIngress7 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:80 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngress8 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:443 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedEgress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:icmp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:0 type:egress]", actualSecurityGroupId, actualDataAwsSecurityGroupDefaultId)
	expectedEgress1 := fmt.Sprintf("map[cidr_blocks:[10.10.0.0/16 10.20.0.0/24] description:managed by Terraform from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:egress]", actualSecurityGroupId)
	expectedEgress2 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:[2001:db8::/64] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:5432 type:egress]", actualSecurityGroupId)
	expectedEgress3 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:0 type:egress]", actualSecurityGroupId)
	expectedEgress4 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:22 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:22 type:egress]", actualDataAwsPrefixListPrivateS3Id, actualSecurityGroupId)
	expectedEgress5 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:80 type:egress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedEgress6 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:egress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedDisabledSgId := "I was not created"

	// assert
	assert.Equal(t, expectedIngress0, actualIngress0, "Map %q should match %q", expectedIngress0, actualIngress0)
	assert.Equal(t, expectedIngress1, actualIngress1, "Map %q should match %q", expectedIngress1, actualIngress1)
	assert.Equal(t, expectedIngress2, actualIngress2, "Map %q should match %q", expectedIngress2, actualIngress2)
	assert.Equal(t, expectedIngress3, actualIngress3, "Map %q should match %q", expectedIngress3, actualIngress3)
	assert.Equal(t, expectedIngress4, actualIngress4, "Map %q should match %q", expectedIngress4, actualIngress4)
	assert.Equal(t, expectedIngress5, actualIngress5, "Map %q should match %q", expectedIngress5, actualIngress5)
	assert.Equal(t, expectedIngress6, actualIngress6, "Map %q should match %q", expectedIngress6, actualIngress6)
	assert.Equal(t, expectedIngress7, actualIngress7, "Map %q should match %q", expectedIngress7, actualIngress7)
	assert.Equal(t, expectedIngress8, actualIngress8, "Map %q should match %q", expectedIngress8, actualIngress8)
	assert.Equal(t, expectedEgress0, actualEgress0, "Map %q should match %q", expectedEgress0, actualEgress0)
	assert.Equal(t, expectedEgress1, actualEgress1, "Map %q should match %q", expectedEgress1, actualEgress1)
	assert.Equal(t, expectedEgress2, actualEgress2, "Map %q should match %q", expectedEgress2, actualEgress2)
	assert.Equal(t, expectedEgress3, actualEgress3, "Map %q should match %q", expectedEgress3, actualEgress3)
	assert.Equal(t, expectedEgress4, actualEgress4, "Map %q should match %q", expectedEgress4, actualEgress4)
	assert.Equal(t, expectedEgress5, actualEgress5, "Map %q should match %q", expectedEgress5, actualEgress5)
	assert.Equal(t, expectedEgress6, actualEgress6, "Map %q should match %q", expectedEgress6, actualEgress6)
	assert.Equal(t, expectedDisabledSgId, actualDisabledSgId, "Map %q should match %q", expectedDisabledSgId, actualDisabledSgId)
}
