local context = std.extVar('context');

{
	'import.tf.json': {
		output: {
			context: {
				value: context
			},
			custom_function: {
				value: std.native('multiply')(12, 42)
			}
		}
	}
}