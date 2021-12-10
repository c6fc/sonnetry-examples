/*

This uses the built-in 'sonnetry.bootstrap()' native function
to create an S3 backend for the named project.

NOTE: This creates the backend bucket the first time the
file is *generated*. Not just when the resulting
configuration is applied.

Sonnetry always uses the same backend bucket within an
account, and the proper Terraform state is identified by the
project name. Thus, you must ensure that distinct states
use distinct project names.

*/

local sonnetry = import 'sonnetry';

local bootstrap = sonnetry.bootstrap('my_test_project');

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