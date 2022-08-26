package test

import (
	"fmt"
	"regexp"
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
	actualTerratest := terraform.OutputMap(t, terraformOptions, "terratest")
	actualDataAwsSecurityGroupDefaultId := actualTerratest["data_aws_security_group_default_id"]
	actualAwsSecurityGroupPreExistingSgId := actualTerratest["aws_security_group_pre_existing_id"]
	actualIngress := terraform.Output(t, terraformOptions, "ingress")
	actualEgress := terraform.Output(t, terraformOptions, "egress")

	regexp, _ := regexp.Compile(`sgrule-[a-z0-9]*`)
	actualIngressWithStaticSgrules := regexp.ReplaceAllString(actualIngress, "sgrule-1111111111")
	actualEgressWithStaticSgrules := regexp.ReplaceAllString(actualEgress, "sgrule-1111111111")

	expectedIngress := fmt.Sprintf(
		"map[ingress-http-80-tcp-from-%s:map[cidr_blocks:<nil> description:ingress-http-80-tcp-from-%s from_port:80 id:sgrule-1111111111 ipv6_cidr_blocks:<nil> prefix_list_ids:<nil> protocol:tcp security_group_id:%s self:false source_security_group_id:sg-b551fece timeouts:<nil> to_port:80 type:ingress]]",
		actualDataAwsSecurityGroupDefaultId, actualDataAwsSecurityGroupDefaultId, actualAwsSecurityGroupPreExistingSgId,
	)
	expectedEgress := "map[]"

	assert.Equal(t, expectedIngress, actualIngressWithStaticSgrules, "Map %q should match %q", expectedIngress, actualIngressWithStaticSgrules)
	assert.Equal(t, expectedEgress, actualEgressWithStaticSgrules, "Map %q should match %q", expectedEgress, actualEgressWithStaticSgrules)

	terraform.ApplyAndIdempotent(t, terraformOptions)
}
