package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCommonRulesExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/common",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected valuesObjectSpec.

	// assign actual
	actualPublicHttpsSecurityGroupId := terraform.Output(t, terraformOptions, "public_https_sg_id")
	actualPublicHttpsIngress := terraform.OutputList(t, terraformOptions, "public_https_ingress")
	actualPublicHttpsEgress := terraform.OutputList(t, terraformOptions, "public_https_egress")

	actualPublicHttpSecurityGroupId := terraform.Output(t, terraformOptions, "public_http_sg_id")
	actualPublicHttpIngress := terraform.OutputList(t, terraformOptions, "public_http_ingress")
	actualPublicHttpEgress := terraform.OutputList(t, terraformOptions, "public_http_egress")

	regexp, _ := regexp.Compile(`sgrule-[a-z0-9]*`)
	actualPublicHttpsIngress0 := regexp.ReplaceAllString(actualPublicHttpsIngress[0], "sgrule-1111111111")
	actualPublicHttpsIngress1 := regexp.ReplaceAllString(actualPublicHttpsIngress[1], "sgrule-1111111111")
	actualPublicHttpsEgress0 := regexp.ReplaceAllString(actualPublicHttpsEgress[0], "sgrule-1111111111")

	actualPublicHttpIngress0 := regexp.ReplaceAllString(actualPublicHttpIngress[0], "sgrule-1111111111")
	actualPublicHttpIngress1 := regexp.ReplaceAllString(actualPublicHttpIngress[1], "sgrule-1111111111")
	actualPublicHttpEgress0 := regexp.ReplaceAllString(actualPublicHttpEgress[0], "sgrule-1111111111")

	// assign expected
	expectedPublicHttpsIngress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:0 type:ingress]", actualPublicHttpsSecurityGroupId)
	expectedPublicHttpsIngress1 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:ingress]", actualPublicHttpsSecurityGroupId)
	expectedPublicHttpsEgress0 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:0 type:egress]", actualPublicHttpsSecurityGroupId)

	expectedPublicHttpIngress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:0 type:ingress]", actualPublicHttpSecurityGroupId)
	expectedPublicHttpIngress1 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:80 type:ingress]", actualPublicHttpSecurityGroupId)
	expectedPublicHttpEgress0 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:0 type:egress]", actualPublicHttpSecurityGroupId)

	// assert
	assert.Equal(t, expectedPublicHttpsIngress0, actualPublicHttpsIngress0, "Map %q should match %q", expectedPublicHttpsIngress0, actualPublicHttpsIngress0)
	assert.Equal(t, expectedPublicHttpsIngress1, actualPublicHttpsIngress1, "Map %q should match %q", expectedPublicHttpsIngress1, actualPublicHttpsIngress1)
	assert.Equal(t, expectedPublicHttpsEgress0, actualPublicHttpsEgress0, "Map %q should match %q", expectedPublicHttpsEgress0, actualPublicHttpsEgress0)

	assert.Equal(t, expectedPublicHttpIngress0, actualPublicHttpIngress0, "Map %q should match %q", expectedPublicHttpIngress0, actualPublicHttpIngress0)
	assert.Equal(t, expectedPublicHttpIngress1, actualPublicHttpIngress1, "Map %q should match %q", expectedPublicHttpIngress1, actualPublicHttpIngress1)
	assert.Equal(t, expectedPublicHttpEgress0, actualPublicHttpEgress0, "Map %q should match %q", expectedPublicHttpEgress0, actualPublicHttpEgress0)
}
