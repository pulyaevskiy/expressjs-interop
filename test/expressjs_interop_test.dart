// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@TestOn('node')
import 'dart:convert';

import 'package:expressjs_interop/expressjs_interop.dart';
import 'package:node_interop/bindings.dart';
import 'package:node_interop/http.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';

void main() {
  installNodeModules({'express': '~4.16.0'});

  group('Express Interop', () {
    Server server;
    setUpAll(() {
      var app = Express.instance();
      app.get('/test-request-fields', (ExpressRequest req, ExpressResponse res,
          [next]) {
        var fields = {
          "baseUrl": req.baseUrl,
          "cookies": req.cookies,
          "fresh": req.fresh,
          "hostname": req.hostname,
          "ip": req.ip,
          "ips": req.ips,
          "method": req.method,
          "originalUrl": req.originalUrl,
          "params": req.params,
          "path": req.path,
          "protocol": req.protocol,
          "query": req.query,
          "secure": req.secure,
          "signedCookies": req.signedCookies,
          "stale": req.stale,
          "subdomains": req.subdomains,
          "xhr": req.xhr,
        };
        res.send(fields);
      });
      server = app.listen(8080);
    });

    tearDownAll(() {
      server.close();
    });

    test('read request fields', () async {
      var client = new NodeClient(keepAlive: false);
      var response =
          await client.get("http://localhost:8080/test-request-fields");
      expect(response.statusCode, 200);
      expect(response.headers['content-type'], 'application/json; charset=utf-8');
      // TODO: figure out why cookies and signedCookies are not in the response.
      expect(JSON.decode(response.body), {
        "baseUrl": "",
        "fresh": false,
        "hostname": 'localhost',
        "ip": "::ffff:127.0.0.1",
        "ips": [],
        "method": "GET",
        "originalUrl": "/test-request-fields",
        "params": {},
        "path": "/test-request-fields",
        "protocol": "http",
        "query": {},
        "secure": false,
        "stale": true,
        "subdomains": [],
        "xhr": false,
      });
    });
  });
}
