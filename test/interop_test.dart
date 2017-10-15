// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@TestOn('node')
import 'dart:convert';
import 'dart:js_util' show setProperty, getProperty;

import 'package:expressjs_interop/expressjs_interop.dart';
import 'package:js/js.dart' as js;
import 'package:node_interop/http.dart';
import 'package:node_interop/node_interop.dart';
import 'package:node_interop/test.dart';
import 'package:test/test.dart';

class User {
  final String id;

  User(this.id);
}

void main() {
  installNodeModules({'express': '~4.16.0'});

  group('Interop', () {
    HttpServer server;
    Application app;

    setUpAll(() {
      ExpressFunction express = node.require('express');
      app = express();
      app.param('userId', js.allowInterop((req, res, next, value, name) {
        setProperty(req, 'user', new User(value));
        next();
      }));
      app.get('/users/:userId', js.allowInterop((req, res, next) {
        User user = getProperty(req, 'user');
        res.send(jsify({'paramFromRequest': user.id}));
      }));
      server = app.listen(8080);
    });

    tearDownAll(() {
      server.close();
    });

    test('happy path', () async {
      var client = new NodeClient(keepAlive: false);
      var response =
      await client.get("http://localhost:8080/users/karl-the-fog");
      expect(response.statusCode, 200);
      expect(JSON.decode(response.body), {"paramFromRequest": "karl-the-fog"});
      client.close();
    });
  });
}
