var http = require('http');
var spawn = require('child_process').spawn;
var createHandler = require('github-webhook-handler');
var handler = createHandler({ path: '/webhook', secret: '******' });

http.createServer(function (req, res) {
    handler(req, res, function (err) {
        res.statusCode = 404;
        res.end('no such location');
    });
}).listen(8088);

console.log('listen at prot 8088');

handler.on('error', function (err) {
    console.error('Error:', err.message);
});

handler.on('push', function (event) {
    console.log('Received a push event for %s to %s', event.payload.repository.name, event.payload.ref);

    runCommand('sh', ['./deploy.sh'], function (txt) {
        console.log(txt);
    });
});

function runCommand(cmd, args, callback) {
    var child = spawn(cmd, args);
    var resp = 'Deploy OK';
    child.stdout.on('data', function (buffer) {
        resp += buffer.toString();
    });
    child.stdout.on('end', function () {
        callback(resp);
    });
}


