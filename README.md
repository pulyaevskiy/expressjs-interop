# Interop library for ExpressJS

[![Build Status](https://img.shields.io/travis-ci/pulyaevskiy/expressjs-interop.svg?branch=master&style=flat-square)](https://travis-ci.org/pulyaevskiy/expressjs-interop) [![Pub](https://img.shields.io/pub/v/expressjs_interop.svg?style=flat-square)](https://pub.dartlang.org/packages/node_interop)

Provides Dart bindings for Express framework JavaScript API.

> Note that this library does not provide support for
> handling object and function conversions between Dart and JS.
> You have to follow [package js](https://pub.dartlang.org/packages/js)
> rules as described in its docs.

## Example

Checkout `example/` folder to see it in action. To build and run:

```bash
$ # 1. Install node dependencies.
$ cd example/
$ npm install
$ cd ../
$
$ # 2. Build the app.
$ pub build example/
$
$ # 3. Run the app.
$ node build/example/index.dart.js
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pulyaevskiy/expressjs-interop/issues
