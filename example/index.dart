import 'package:expressjs_interop/expressjs_interop.dart';
import 'package:js/js.dart';
import 'package:node_interop/node_interop.dart';

void main() {
  ExpressFunction express = node.require('express');
  var app = express();
  app.get('/', allowInterop((Request req, Response res, NextFunction next) {
    print('Request received: ${req.url}');
    res.send(jsify({"result": "OK"}));
  }));
  app.listen(8080);
}
