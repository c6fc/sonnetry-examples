/*

This example uses the built-in `aws.providerAliases()`
and `sonnetry.envvar()` to generate a list of AWS
providers with one alias for each region, with the
default provider being the current AWS_DEFAULT_REGION
or "us-east-1".

Aliases can then be accessed as 'aws.<region>'

*/

local aws = import 'aws-sdk';

{
	'provider.tf.json': {
		terraform: {
			required_providers: {
				aws: {
					source: "hashicorp/aws",
					version: "~> 3.57.0"
				}
			}
		},
		provider: aws.providerAliases()
	}
}