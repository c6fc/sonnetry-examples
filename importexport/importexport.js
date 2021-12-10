const { Sonnet } = require('@c6fc/sonnetry');

(async () => {
  const sonnetry = new Sonnet({
    // The folder to write the configurations into
    renderPath: '../render',

    // Whether to delete the *.tf.json files from the renderPath before rendering    
    cleanBeforeRender: true
  });

  const context = {
    my_first_var: "test",
    my_second_var: [1, "two", { three: true }],
    my_third_var: null
  };

  // Export the 'context' variable above to make it
  // available as std.extVar('context') Jsonnet
  sonnetry.export('context', context);

  // Add a custom function that can be accessed via 'std.native()'
  // Custom functions can also accept returned promises.
  sonnetry.addFunction('multiply', (a, b) => {
    return a * b;
  }, "a", "b");

  // Render the Jsonnet file, returning a raw object.
  const json = await sonnetry.render('importexport.jsonnet');

  // Save the most recent render to the renderPath.
  sonnetry.write();

  // Run `terraform apply` on the rendered files.
  sonnetry.apply(true, true);
})();