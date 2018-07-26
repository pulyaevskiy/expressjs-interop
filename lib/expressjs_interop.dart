// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Dart bindings for Express JavaScript API.
@JS()
library expressjs_interop;

import 'package:js/js.dart';
import 'package:node_interop/events.dart';
import 'package:node_interop/http.dart';
import 'package:node_interop/node_interop.dart';

/// List of application setting names.
///
/// See also:
///   - [Application.disable]
///   - [Application.disabled]
///   - [Application.enable]
///   - [Application.set]
///   - [Application.get]
abstract class ApplicationSetting {
  static const String caseSensitiveRouting = 'case sensitive routing';
  static const String env = 'env';
  static const String etag = 'etag';
  static const String jsonpCallbackName = 'jsonp callback name';
  static const String jsonEscape = 'json escape';
  static const String jsonReplacer = 'json replacer';
  static const String jsonSpaces = 'json spaces';
  static const String queryParser = 'query parser';
  static const String strictRouting = 'strict routing';
  static const String subdomainOffset = 'subdomain offset';
  static const String trustProxy = 'trust proxy';
  static const String views = 'views';
  static const String viewCache = 'view cache';
  static const String viewEngine = 'view engine';
  static const String xPoweredBy = 'x-powered-by';
}

/// Creates a new instance of Express [Application].
///
/// Usage:
///
///     ExpressFunction express = require('express');
///     Application app = express();
///     app.get('/', handler);
///
/// This definition exists as a workaround for an issue in JS interop which
/// prevents declaring `call` methods on interop classes. For details see:
/// https://github.com/dart-lang/sdk/issues/30969
///
/// In case the above issue gets resolved this type definition will be
/// deprecated.
///
/// See also:
///
///   - [Express]
@JS()
typedef Application ExpressFunction();

/// Main class of Express module.
@JS()
abstract class Express {
  // JS interop bug in Dart SDK prevents us from making interop classes
  // callable.
  // See for details: https://github.com/dart-lang/sdk/issues/30969
//  external Application call();

  external dynamic static(root, [options]);
  external dynamic Router([options]);
}

@JS()
abstract class Application implements EventEmitter {
  // JS interop bug in Dart SDK prevents us from making interop classes
  // callable.
  // See for details: https://github.com/dart-lang/sdk/issues/30969
//  external void call(req, res, [next]);

  external dynamic get locals;

  /// Contains one or more path patterns on which a sub-app was mounted.
  external dynamic get mountpath;

  /// Matches all HTTP verbs for [path].
  ///
  /// [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void all(String path, dynamic handlers);

  /// Routes HTTP DELETE requests to the specified [path] with the specified
  /// handler functions.
  ///
  /// [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void delete(String path, dynamic handlers);

  /// Sets the Boolean setting name to `false`, where name is one of the
  /// constants from [ApplicationSetting].
  ///
  /// This is the same as calling `set(name, false)`.
  external void disable(String name);

  /// Returns `true` if the Boolean setting [name] is disabled (false).
  ///
  /// The name is one of the constants from [ApplicationSetting].
  external bool disabled(String name);

  /// Sets the Boolean setting name to `true`, where name is one of the
  /// constants from [ApplicationSetting].
  ///
  /// This is the same as calling `set(name, true)`.
  external void enable(String name);
  external void engine(String ext, callback);

  /// Routes HTTP GET requests to the specified [path] with the specified
  /// handler functions.
  ///
  /// [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void get(String path, dynamic handlers);
  external HttpServer listen(int port, [String hostname, backlog, callback]);
  external void param(dynamic param, RequestParamHandler handler);
  external String path();

  /// Routes HTTP POST requests to the specified [path] with the specified
  /// handler functions.
  ///
  /// [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void post(String path, dynamic handlers);

  /// Routes HTTP PUT requests to the specified [path] with the specified
  /// handler functions.
  ///
  /// [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void put(String path, dynamic handlers);
  external String render(view, locals, callback(err, html));
  external Route route(String path);
  external void set(String name, dynamic value);

  /// Mounts the specified [handlers] at the specified path.
  ///
  /// The handlers are executed when the base of the requested path matches
  /// path. [handlers] can be either [Middleware] or a `List<Middleware>`.
  external void use(String path, dynamic handlers);
}

@JS()
abstract class Route {
  external String get path;
  external Route all(Middleware handler);
  external Route get(Middleware handler);
  external Route post(Middleware handler);
  external Route put(Middleware handler);
  external Route delete(Middleware handler);
}

typedef void NextFunction([err]);
typedef void Middleware(Request req, Response res, NextFunction next);
typedef void ErrorHandlingMiddleware(
    error, Request req, Response res, NextFunction next);
typedef dynamic RequestParamHandler(
    Request req, Response res, NextFunction next, dynamic value,
    String name);

@JS()
abstract class Request implements IncomingMessage {
  external Application get app;
  external String get baseUrl;
  external dynamic get body;
  external dynamic get cookies;
  external bool get fresh;
  external String get hostname;
  external String get ip;
  external List<String> get ips;
  external String get originalUrl;
  external dynamic get params;
  external String get path;
  external String get protocol;
  external dynamic get query;
  external dynamic get route;
  external bool get secure;
  external dynamic get signedCookies;
  external bool get stale;
  external List<String> get subdomains;
  external bool get xhr;

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
abstract class Response implements ServerResponse {
  external Application get app;
  external bool get headersSent;
  external dynamic get locals;
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
  external Function get encode;
  external Date get expires;
  external bool get httpOnly;
  external num get maxAge;
  external String get path;
  external bool get secure;
  external dynamic get sameSite;

  external factory CookieOptions({
    String domain,
    Function encode,
    Date expires,
    bool httpOnly,
    num maxAge,
    String path,
    bool secure,
    dynamic sameSite,
  });
}
