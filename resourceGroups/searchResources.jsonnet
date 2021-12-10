/*


*/

local aws = import 'aws-sdk';

local getBootstrapBucket() =
	local resources = aws.api(
		aws.client('ResourceGroups'),
		'searchResources',
		{
			ResourceQuery: {
				Type: "TAG_FILTERS_1_0",
				Query: std.manifestJsonEx({
					ResourceTypeFilters: ["AWS::S3::Bucket"],
					TagFilters: [{
						Key: "sonnetry-project",
						Values: ["true"]
					}]
				}, '')
			}
		}
	).ResourceIdentifiers;

	if (std.length(resources) > 0) then
		resources[0]
	else
		false;

{
	'output.tf.json': {
		output: {
			bucket: {
				value: getBootstrapBucket()
			}
		}
	}
}