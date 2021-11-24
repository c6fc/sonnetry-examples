/*

This uses the built-in 'sonnetry.bootstrap' native function
to create an S3 backend for the named project.

*/

local aws = import 'aws-sdk';
local sonnetry = import 'sonnetry';

local bootstrap = sonnetry.bootstrap('test_project');

{
	'backend.tf.json': bootstrap,
	'bucket.tf.json': {
		output: {
			backend_bucket: {
				value: bootstrap.terraform.backend.s3.bucket
			}
		}
	}
}