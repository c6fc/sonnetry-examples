/*

This example uses an imported library to provide shortcuts for
common infrastructure patterns. Jsonnet is incredibly powerful
when used this way, as you can produce a lot of components with
very little code.

The built-in 'aws.getAvailabilityZones' returns all regions and
associated availability zones within the account, structured
like this:

{
	"us-west-1": ["us-west-1a", "us-west-1b"...]
	"us-west-2": ...
	...
}

The function used here is defined in vpc.libsonnet:
	vpc.public_vpc(
		basename: the base name to use for all resources
		region: which region to create the VPC in
		cidr: The cidr mask to use for the VPC.
			Subnets will be distributed evenly within this CIDR with smaller masks.
		azs: An array of availability zones to create subnets within.
		segmentoffset: Leave room for this many more subnets within the VPC.
		baseendpoints: An array of VPC Endpoints to create and associate.
			Use only the service-specific name. The region is applied automatically.
	)

*/

local aws = import 'aws-sdk';
local vpc = import './libsonnet/vpc.libsonnet';

local azs = aws.getAvailabilityZones();

{
	'vpc.tf.json': vpc.public_vpc(
			"us-east-1_public",
			"us-east-1",
			"10.24.18.0/20",
			azs["us-east-1"],
			0,
			["s3", "dynamodb", "lambda"]
		)
}