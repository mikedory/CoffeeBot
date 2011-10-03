var http, port, server, sys;
sys = require('sys');
http = require('http');
server = http.createServer(function(req, res) {
  res.writeHeader(200, {
    'Content-Type': 'text/plain'
  });
  res.write('CoffeeBot!');
  return res.end();
});
server.listen(port = 3000);
sys.puts("Server running at http://localhost:" + port + "/");