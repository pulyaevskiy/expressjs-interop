@JS()
library expressjs_example;

import 'package:expressjs_interop/bindings.dart';
import 'package:js/js.dart';
import 'package:node_interop/bindings.dart';

void main() {
  Express express = require('express');
  var app = express();
  app.get('/test', allowInterop((ExpressRequest req, ExpressResponse res, [next]) {
    print('Request received: ${req.url}');
    res.send('data');
  }));
  app.listen(8080);
}
