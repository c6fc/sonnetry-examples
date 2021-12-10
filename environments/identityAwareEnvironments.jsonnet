/*

Access environment variables based on the identity of the invoker.

*/

local aws = import 'aws-sdk';

// Get our current identity
local identity = aws.getCallerIdentity().Arn;

// Define a map of variables based on identity
local environments = {
	"arn:aws:sts::123456789012:assumed-role/Deploy": {
		stage: "development"
	},
	"arn:aws:sts::234567890123:assumed-role/Deploy": {
		stage: "staging"
	},
	"arn:aws:sts::345678901234:assumed-role/Deploy": {
		stage: "production"
	}
};

// Assert that our current identity matches a defined mapping
assert std.objectHas(environment, identity);

local environment = environments[identity];

{
	'environment.tf.json': {
		output: {
			environment_stage: {
				value: environment.stage
			}
		}
	}
}