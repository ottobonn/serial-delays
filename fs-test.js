var request = require("request");
var fs = require("fs");

var requestCounter = 0;
var responseCounter = 0;

function makeRequest () {
  console.log("made request " + requestCounter++);
  request("http://httpbin.org/get", function (error, response, body) {
    console.log("received response to request " + responseCounter++);
  });
}

var filename = "dummy-file.txt";
readFile(filename);

function readFile (filename) {
  console.log("started reading file");
  fs.readFile(filename, function (err, data) {
    console.log("read file: " + data);
    readFile(filename);
    makeRequest();
  });
}
