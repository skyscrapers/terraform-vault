package test

import (
	"testing"
	"fmt"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestBasicExample(t *testing.T) {
	t.Parallel()

	uniqueId := random.UniqueId()
	projectName := fmt.Sprintf("vault-%s", uniqueId)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"vault_acm_arn": "arn:aws:acm:eu-west-1:847239549153:certificate/3e1518ab-342b-44a2-86ba-a882d9da1fa5",
			"vault_dns_root": "test.skyscrape.rs",
			"vault_version": "0.9.3",
			"project": projectName,
			"le_staging": true,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "eu-west-1",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
