local aws = import 'aws-sdk';

local regionList = aws.getRegionsList();

{
	'cdk.tf.json': {
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
				alias: 'aws.' + region,
				region: region
			}, for region in regionList]
		},
		resource: {
			aws_vpc: {
				['test-%s' % region]: {
					alias: 'aws.' + region,
					cidr_block: "10.0.0.0/16"
				} for region in regionList
			},
			aws_subnet: {
				['test-%s' % region]: {
					alias: 'aws.' + region,
					vpc_id: "${aws_vpc.test-%s.id}" % region
				} for region in regionList
			}
		},
		test: "${aws_subnet.test-us-west-2.my_config}"
	}
}