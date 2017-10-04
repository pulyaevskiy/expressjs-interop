import 'package:expressjs_interop/expressjs_interop.dart';

void main() {
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
  app.listen(8080);
}
