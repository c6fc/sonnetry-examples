local context = std.extVar('context');

{
	'import.tf.json': {
		output: {
			context: {
				value: context
			}
		}
	}
}