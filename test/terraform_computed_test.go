package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformComputedRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/computed",

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
	actualEgress0 := regexp.ReplaceAllString(actualEgress[0], "sgrule-1111111111")
	actualEgress1 := regexp.ReplaceAllString(actualEgress[1], "sgrule-1111111111")
	actualEgress2 := regexp.ReplaceAllString(actualEgress[2], "sgrule-1111111111")
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualAwsSecurityGroupOtherId := actualTerratest["aws_security_group_other_id"]
	actualAwsEc2ManagedPrefixListOtherId := actualTerratest["aws_ec2_managed_prefix_list_other_id"]
	actualIngressCount := actualTerratest["ingress_count"]
	actualEgressCount := actualTerratest["egress_count"]

	// assign expected
	expectedIngress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:80 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngress1 := fmt.Sprintf("map[cidr_blocks:<nil> description:HTTPS from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:443 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngress2 := fmt.Sprintf("map[cidr_blocks:[10.0.0.0/24 10.0.1.0/24] description:PostgreSQL from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:[] prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:5432 type:ingress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedIngress3 := fmt.Sprintf("map[cidr_blocks:[10.0.0.0/24 10.0.1.0/24] description:customer rule example from_port:22 id:sgrule-1111111111 ipv6_cidr_blocks:[] prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:22 type:ingress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedIngress4 := fmt.Sprintf("map[cidr_blocks:<nil> description:PostgreSQL from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:5432 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngress5 := fmt.Sprintf("map[cidr_blocks:<nil> description:customer rule example from_port:22 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:22 type:ingress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngress6 := fmt.Sprintf("map[cidr_blocks:<nil> description:PostgreSQL from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:5432 type:ingress]", actualSecurityGroupId)
	expectedIngress7 := fmt.Sprintf("map[cidr_blocks:<nil> description:customer rule example from_port:22 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:22 type:ingress]", actualSecurityGroupId)
	expectedEgress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:80 type:egress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedEgress1 := fmt.Sprintf("map[cidr_blocks:<nil> description:HTTPS from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:[%s] protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:egress]", actualAwsEc2ManagedPrefixListOtherId, actualSecurityGroupId)
	expectedEgress2 := fmt.Sprintf("map[cidr_blocks:<nil> description:PostgreSQL from_port:5432 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:5432 type:egress]", actualSecurityGroupId, actualAwsSecurityGroupOtherId)
	expectedIngressCount := "8"
	expectedEgressCount := "3"

	// assert
	assert.Equal(t, expectedIngress0, actualIngress0, "Map %q should match %q", expectedIngress0, actualIngress0)
	assert.Equal(t, expectedIngress1, actualIngress1, "Map %q should match %q", expectedIngress1, actualIngress1)
	assert.Equal(t, expectedIngress2, actualIngress2, "Map %q should match %q", expectedIngress2, actualIngress2)
	assert.Equal(t, expectedIngress3, actualIngress3, "Map %q should match %q", expectedIngress3, actualIngress3)
	assert.Equal(t, expectedIngress4, actualIngress4, "Map %q should match %q", expectedIngress4, actualIngress4)
	assert.Equal(t, expectedIngress5, actualIngress5, "Map %q should match %q", expectedIngress5, actualIngress5)
	assert.Equal(t, expectedIngress6, actualIngress6, "Map %q should match %q", expectedIngress6, actualIngress6)
	assert.Equal(t, expectedIngress7, actualIngress7, "Map %q should match %q", expectedIngress7, actualIngress7)
	assert.Equal(t, expectedEgress0, actualEgress0, "Map %q should match %q", expectedEgress0, actualEgress0)
	assert.Equal(t, expectedEgress1, actualEgress1, "Map %q should match %q", expectedEgress1, actualEgress1)
	assert.Equal(t, expectedEgress2, actualEgress2, "Map %q should match %q", expectedEgress2, actualEgress2)
	assert.Equal(t, expectedIngressCount, actualIngressCount, "Map %q should match %q", expectedIngressCount, actualIngressCount)
	assert.Equal(t, expectedEgressCount, actualEgressCount, "Map %q should match %q", expectedEgressCount, actualEgressCount)
}
