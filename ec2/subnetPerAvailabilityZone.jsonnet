local aws = import 'aws-sdk';

local azs = aws.getAvailabilityZones();
local regionKeys = std.objectFields(azs);

// Since Jsonnet doesn't have a log2(), we need to do some hackery.
// This only works up to 17, but that should be more than plenty.
local log2map = [0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5];

{
	'provider.tf.json': {
		terraform: {
			required_providers: {
				aws: {
					version: "~> 3.42",
					source: "hashicorp/aws"
				}
			}
		},
		provider: {
			aws: [{
				local region = regionKeys[i],

				alias: 'aws.' + region,
				region: region,
			} for i in std.range(0, std.length(regionKeys) - 1)]
		}
	},
	'vpc.tf.json': {
		resource: {
			aws_vpc: {
				['test-%s' % regionKeys[i]]: {
					local region = regionKeys[i],

					provider: 'aws.' + region,
					cidr_block: "10.%d.0.0/16" % i
				} for i in std.range(0, std.length(regionKeys) - 1)
			},
			aws_subnet: {

				['test-%s' % azs[regionKeys[i]][az]]: {
					local region = regionKeys[i],
					local azName = azs[region][az],

					provider: 'aws.' + region,
					cidr_block: "${cidrsubnet(aws_vpc.test-%s.cidr_block, %d, %d)}" % [region, log2map[std.length(azs[region])], i],
					vpc_id: "${aws_vpc.test-%s.id}" % azName
				}
				for i in std.range(0, std.length(regionKeys) - 1)
				for az in std.range(0, std.length(azs[regionKeys[i]]) - 1)
			}
		},
		output: {
			test: {
				value: "${aws_subnet.test-us-west-2.my_config}"
			}
		}
	}
}