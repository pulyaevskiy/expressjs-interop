// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// ExpressJS bindings.
@JS()
library expressjs_interop.bindings;

import 'dart:js';

import 'package:js/js.dart';
import 'package:node_interop/bindings.dart';

@JS()
abstract class Express {
  external Application call();
  external dynamic static(root, [options]);
  external dynamic Router([options]);
}

@JS()
abstract class Application {
  external void call(req, res, [next]);
  external JsObject get locals;
  external dynamic get mountpath;
  external void all(String path, Middleware callback);
  external void delete(String path, Middleware callback);
  external void disable(String name);
  external bool disabled(String name);
  external void enable(String name);
  external void engine(String ext, callback);
  external void get(String path, Middleware callback);
  external Server listen(int port, [String hostname, backlog, callback]);
  external void param(dynamic param, callback);
  external String path();
  external void post(String path, Middleware callback);
  external void put(String path, Middleware callback);
  external String render(view, locals, callback(err, html));
  external dynamic route(String path);
  external void set(String name, dynamic value);
  external void use(String path, Middleware callback);
  external void on(String event, callback);
}

typedef void Middleware(ExpressRequest req, ExpressResponse res,
    [JsFunction next]);

@JS()
abstract class ExpressRequest implements IncomingMessage {
  external Application get app;
  external String get baseUrl;
  external dynamic get body;
  external dynamic get cookies;
  external bool get fresh;
  external String get hostname;
  external String get ip;
  external JsArray<String> get ips;
  external String get method;
  external String get originalUrl;
  external dynamic get params;
  external String get path;
  external String get protocol;
  external dynamic get query;
  external dynamic get route;
  external bool get secure;
  external dynamic get signedCookies;
  external bool get stale;
  external JsArray<String> get subdomains;
  external bool get xhr;

  // Methods
  external String accepts(String types);
  external dynamic acceptsCharsets(String charset1,
      [String charset2, String charset3]);
  external dynamic acceptsEncodings(String encoding1,
      [String encoding2, String encoding3]);
  external dynamic acceptsLanguages(String lang1, [String lang2, String lang3]);
  external String get(String field);
  // `is()` excluded as it's not allowed in Dart as a method name.
  external dynamic param(String name, [dynamic defaultValue]);
  external dynamic range(int size, [options]);
}

@JS()
abstract class ExpressResponse implements ServerResponse {
  external Application get app;
  external bool get headersSent;
  external JsObject get locals;
  external void append(String field, [dynamic value]);
  external void attachment([String filename]);
  external void cookie(String name, dynamic value, [CookieOptions options]);
  external void clearCookie(String name, [CookieOptions options]);
  external void download(String path, [String filename, fn]);
  external void format(object);
  external dynamic get(String field);
  external void json([body]);
  external void jsonp([body]);
  external void links(links);
  external void location(String path);
  external void redirect(num status, String path);
  external void render(view, locals, callback(err, html));
  external void send([dynamic body]);
  external void sendFile(String path, [SendFileOptions options, fn]);
  external void sendStatus(num statusCode);
  external void set(String field, [value]);
  external void status(num statusCode);
  external void type(String type);
  external void vary(String field);
}

@JS()
@anonymous
abstract class SendFileOptions {
  external num get maxAge;
  external String get root;
  external bool get lastModified;
  external dynamic get headers;
  external String get dotfiles;
  external bool get acceptRanges;
  external bool get cacheControl;

  external factory SendFileOptions({
    num maxAge,
    String root,
    bool lastModified,
    dynamic headers,
    String dotfiles,
    bool acceptRanges,
    bool cacheControl,
  });
}

@JS()
@anonymous
abstract class CookieOptions {
  external String get domain;
  external JsFunction get encode;
  external Date get expires;
  external bool get httpOnly;
  external num get maxAge;
  external String get path;
  external bool get secure;
  external dynamic get sameSite;

  external factory CookieOptions({
    String domain,
    JsFunction encode,
    Date expires,
    bool httpOnly,
    num maxAge,
    String path,
    bool secure,
    dynamic sameSite,
  });
}
