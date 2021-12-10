/*

This example uses the built-in `aws.assertIdentity()`
function to forcibly terminate execution if the current
identity doesn't match the provided value.

Because of Jsonnet's lazy interpolation, the value of
this function must be rendered. Otherwise it will be
skipped. This is best accomplished through an 'output'
as shown here.

NOTE: Running this as-is will return an error. This is
intended behavior. Replacing the ARN with your own will
allow the generation to proceed.

*/

local aws = import 'aws-sdk';

{
	'assertIdentity.tf.json': {
		output: {
			identity: {
				value: aws.assertIdentity('arn:aws:sts::123456789012:assumed-role/Deploy')
			}
		}
	}
}