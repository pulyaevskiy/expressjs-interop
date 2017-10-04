// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library expressjs_interop;

import 'dart:async';
import 'dart:js';
import 'dart:js_util';
import 'package:node_interop/bindings.dart';
import 'package:node_interop/node_interop.dart';
import 'bindings.dart' as js;

final js.Express _jsExpress = require('express');

/// Main class of Express library.
///
/// Use static getter [instance] as an entry point. For instance, to create
/// an Express application:
///
///     Application app = Express.instance();
///
/// Wraps around native object returned from `require('express')`.
class Express {
  /// Instance of native JavaScript Express object.
  final js.Express nativeInstance;

  /// Returns singleton instance of this class.
  static Express get instance => _instance ??= new Express._(_jsExpress);
  static Express _instance;

  Express._(this.nativeInstance);

  Application call() => new Application(nativeInstance());
}

typedef void ExpressMiddleware(ExpressRequest request, ExpressResponse response,
    [next()]);

/// Express Application.
class Application {
  final js.Application nativeInstance;

  Application(this.nativeInstance);

  void all(String path, ExpressMiddleware listener) =>
      nativeInstance.all(path, _wrapListener(listener));
  void delete(String path, ExpressMiddleware listener) =>
      nativeInstance.delete(path, _wrapListener(listener));
  void get(String path, ExpressMiddleware listener) =>
      nativeInstance.get(path, _wrapListener(listener));
  void post(String path, ExpressMiddleware listener) =>
      nativeInstance.post(path, _wrapListener(listener));
  void put(String path, ExpressMiddleware listener) =>
      nativeInstance.put(path, _wrapListener(listener));

  Function _wrapListener(ExpressMiddleware listener) =>
      allowInterop((js.ExpressRequest request, js.ExpressResponse response,
          [Function next]) {
        var req = new ExpressRequest(request);
        var res = new ExpressResponse(response);
        var wrappedNext = () {
          next();
        };
        listener(req, res, wrappedNext);
      });

  Server listen(int port) {
    return nativeInstance.listen(port);
  }
}

/// Express HTTP request.
class ExpressRequest {
  final js.ExpressRequest nativeInstance;

  ExpressRequest(this.nativeInstance);

  /// The URL path on which a router instance was mounted.
  String get baseUrl => nativeInstance.baseUrl;
  Map<String, dynamic> get body =>
      nativeInstance.body ?? jsObjectToMap(nativeInstance.body);

  Map<String, dynamic> get cookies => jsObjectToMap(nativeInstance.cookies);

  bool get fresh => nativeInstance.fresh;
  String get hostname => nativeInstance.hostname;
  String get ip => nativeInstance.ip;
  List<String> get ips => (nativeInstance.ips != null)
      ? nativeInstance.ips.toList(growable: false)
      : [];
  String get method => nativeInstance.method;
  String get originalUrl => nativeInstance.originalUrl;
  Map<String, dynamic> get params => jsObjectToMap(nativeInstance.params);
  String get path => nativeInstance.path;
  String get protocol => nativeInstance.protocol;
  Map<String, dynamic> get query => jsObjectToMap(nativeInstance.query);
  bool get secure => nativeInstance.secure;
  Map<String, dynamic> get signedCookies =>
      jsObjectToMap(nativeInstance.signedCookies);
  bool get stale => nativeInstance.stale;
  List<String> get subdomains => (nativeInstance.subdomains != null)
      ? nativeInstance.subdomains.toList(growable: false)
      : [];
  bool get xhr => nativeInstance.xhr;
}

/// Express HTTP response.
class ExpressResponse {
  final js.ExpressResponse nativeInstance;
  ExpressResponse(this.nativeInstance);

  bool get headersSent => nativeInstance.headersSent;

  Map<String, dynamic> get locals => jsObjectToMap(nativeInstance.locals);

  bool _isPrimitiveType(object) =>
      (object is num) ||
      (object is String) ||
      (object is bool) ||
      (object == null);

  /// Sets the HTTP response Content-Disposition header field to “attachment”.
  ///
  /// If a filename is given, then it sets the Content-Type based on the
  /// extension name, and sets the Content-Disposition “filename=” parameter.
  void attachment([String filename]) {
    nativeInstance.attachment(filename);
  }

  /// Sets cookie [name] to [value].
  void cookie(String name, String value) {
    nativeInstance.cookie(name, value);
  }

  /// Clears the cookie specified by [name].
  void clearCookie(String name) {
    nativeInstance.clearCookie(name);
  }

  /// Ends the response process.
  ///
  /// Use to quickly end the response without any data. Use [send] or [json]
  /// to create response with a body.
  void end() => nativeInstance.end();

  /// Returns the HTTP response header specified by field.
  ///
  /// The match is case-insensitive.
  String get(String name) => nativeInstance.get(name);

  /// Sends a JSON response.
  ///
  /// This method sends a response (with the correct content-type).
  void json([dynamic body]) {
    var jsObject = _isPrimitiveType(body) ? body : jsify(body);
    nativeInstance.json(jsObject);
  }

  /// Sets "Location" HTTP header for this response to the specified [path]
  /// parameter.
  void location(String path) {
    nativeInstance.location(path);
  }

  /// Redirects to the URL derived from the specified [path], with specified
  /// [statusCode].
  ///
  /// If not specified, `statusCode` defaults to "302 Found".
  void redirect(String path, [int statusCode = 302]) {
    nativeInstance.redirect(statusCode, path);
  }

  /// Sends the HTTP response.
  ///
  /// The [body] parameter can be a String, a Map, or any Iterable.
  void send([dynamic body]) {
    var jsObject = _isPrimitiveType(body) ? body : jsify(body);
    nativeInstance.send(jsObject);
  }

  /// Transfers the file at the given path.
  ///
  /// Sets the Content-Type response HTTP header field based on the filename’s
  /// extension. Unless the root option is set in the options object, [path]
  /// must be an absolute path to the file.
  ///
  /// Returned Future completes when the transfer is complete or when an error
  /// occurs.
  Future<Null> sendFile(
    String path, {
    int maxAge: 0,
    String root,
    bool lastModified: true,
    String dotfiles: "ignore",
    bool acceptRanges: true,
    bool cacheControl: true,
  }) {
    var completer = new Completer();
    var options = new js.SendFileOptions(
      maxAge: maxAge,
      root: root,
      lastModified: lastModified,
      dotfiles: dotfiles,
      acceptRanges: acceptRanges,
      cacheControl: cacheControl,
    );
    nativeInstance.sendFile(path, options, allowInterop((error) {
      if (error != null) {
        completer.completeError(error); // TODO: dartify error?
      } else
        completer.complete();
    }));
    return completer.future;
  }

  /// Sets the response HTTP status code to statusCode and send its string
  /// representation as the response body.
  void sendStatus(int statusCode) => nativeInstance.sendStatus(statusCode);

  /// Sets the response’s HTTP header field to value.
  ///
  ///     response.set('Content-Type', 'text/plain');
  void set(String name, String value) => nativeInstance.set(name, value);

  /// Sets the HTTP status for the response.
  ///
  /// Unlike native counterpart this method is not chainable because Dart
  /// provides Cascade notation (`..`) for any instance method.
  void status(int statusCode) {
    nativeInstance.status(statusCode);
  }

  /// Sets the Content-Type HTTP header to the MIME type as determined
  /// by mime.lookup() for the specified type. If type contains the “/”
  /// character, then it sets the Content-Type to type.
  void type(String type) {
    nativeInstance.type(type);
  }
}
