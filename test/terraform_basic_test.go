package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformBasicExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/basic",

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
	actualEgress0 := regexp.ReplaceAllString(actualEgress[0], "sgrule-1111111111")

	// assign expected
	expectedIngress0 := fmt.Sprintf("map[cidr_blocks:[10.0.0.0/24] description:My Private Service from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:443 type:ingress]", actualSecurityGroupId)
	expectedIngress1 := fmt.Sprintf("map[cidr_blocks:<nil> description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:true source_security_group_id:<nil> timeouts:<nil> to_port:0 type:ingress]", actualSecurityGroupId)
	expectedEgress0 := fmt.Sprintf("map[cidr_blocks:[0.0.0.0/0] description:managed by Terraform from_port:0 id:sgrule-1111111111 ipv6_cidr_blocks:[::/0] prefix_list_ids:<nil> protocol:-1 security_group_id:%s self:false source_security_group_id:<nil> timeouts:<nil> to_port:0 type:egress]", actualSecurityGroupId)

	// assert
	assert.Equal(t, expectedIngress0, actualIngress0, "Map %q should match %q", expectedIngress0, actualIngress0)
	assert.Equal(t, expectedIngress1, actualIngress1, "Map %q should match %q", expectedIngress1, actualIngress1)
	assert.Equal(t, expectedEgress0, actualEgress0, "Map %q should match %q", expectedEgress0, actualEgress0)
}
