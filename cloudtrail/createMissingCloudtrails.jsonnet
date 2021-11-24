/*

This example first inspects all regions for the presence of at least
one Cloudtrail trail, returning a list of regions that have none.

If there is at least one region without a Cloudtrail, create an S3
bucket in the first missing region, create CloudTrail trails in each region, and 
forward them all to the bucket.

If there are no regions without Cloudtrail, do nothing.

*/

local aws = import 'aws-sdk';

local regionsList = aws.getRegionsList();
local regionsWithoutCloudTrail =
	std.filter(
		function (x) x != false,
		std.map(
			function(region) if (std.length(aws.api(
				aws.client('CloudTrail', { region: "us-west-2" }),
				'listTrails'
			)) == 0) then region else false,
			regionsList
		));

{
	[if (std.length(regionsWithoutCloudTrail) > 0) then 'missingCloudTrails.tf.json' else null]: {
		resource: {
			aws_cloudtrail: {
				[region]: {
					provider: "aws." + region,


				} for region in regionsWithoutCloudTrail
			},
			aws_s3_bucket: {
				["cloudtrail-%s" % [region]]: {
					provider: "aws." + region,
					name_prefix: "cloudtrail-%s" % [region],

					force_destroy: true,
					policy: std.manifestJsonEx({
						whatever: [{
							statement: "a thing"
							}]
						}, '')
				} for region in regionsWithoutCloudTrail[0:1:1]
			}
		}
	},
	'provider.tf.json': {
		terraform: {
			required_providers: {
				aws: {
					source: "hashicorp/aws",
					version: "~> 3.57.0"
				}
			}
		},
		provider: [{
			aws: {
				alias: region,
				region: region
			}
		} for region in regionsList ]
	},
}