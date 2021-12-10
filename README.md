# @c6fc/sonnetry examples

This repo contains infrastructure-as-code examples written for Sonnetry. Each example has its own notes.

## How to use

It's recommended that you only perform a local npm installation for these examples:

```sh
$ git clone https://github.com/c6fc/sonnetry-examples
$ cd sonnetry-examples
$ npm install
```

Once installed, you can use the 'sonnetry generate' command to generate configurations based on the example files. This will create a new folder called 'render' with our rendered content in it.
```sh
$ npx sonnetry generate built-ins/getCallerIdentity.jsonnet
$ cat render/identity.tf.json
```

## Import/Export example

The `importexport` folder contains an example of how you can use the library to extend the capabilities of Sonnetry even further. To test it out, use the following commands:

```sh
$ cd importexport
$ node importexport.js
```