package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformSourceSecurityGroupIdsExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/source_security_group_ids",

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
	regexp, _ := regexp.Compile(`sgrule-[a-z0-9]*`)
	actualIngress0 := regexp.ReplaceAllString(actualIngress[0], "sgrule-1111111111")
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualDataAwsSecurityGroupDefaultId := actualTerratest["data_aws_security_group_default_id"]
	actualIngressCount := actualTerratest["ingress_count"]

	// assign expected
	expectedIngress0 := fmt.Sprintf("map[cidr_blocks:<nil> description:HTTPS from_port:443 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:%s timeouts:<nil> to_port:443 type:ingress]", actualSecurityGroupId, actualDataAwsSecurityGroupDefaultId)
	expectedIngressCount := "1"

	// assert
	assert.Equal(t, expectedIngress0, actualIngress0, "Map %q should match %q", expectedIngress0, actualIngress0)
	assert.Equal(t, expectedIngressCount, actualIngressCount, "Map %q should match %q", expectedIngressCount, actualIngressCount)
}
