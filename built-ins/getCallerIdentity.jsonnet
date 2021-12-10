/*

This example shows multiple different ways of obtaining
the current AWS identity. Every output will have the same value.

*/

local aws = import 'aws-sdk';

{
	'identity.tf.json': {
		output: {
			builtin: {
				value: aws.getCallerIdentity().Arn
			},
			call: {
				value: aws.call('STS', 'getCallerIdentity').Arn
			},
			clientapi: {
				value: aws.api(
						aws.client('STS', { region: "us-east-1" }),
						'getCallerIdentity'
					).Arn
			}
		}
	}
}