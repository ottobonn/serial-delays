var request = require("request");
var fs = require("fs");

var requestCounter = 0;
var responseCounter = 0;

// Change useIP to true to use IP addresses instead of URLs for reqests.
// Using IP addresses bypasses DNS, so the slowdown should disappear.
var useIP = false;

function makeRequest () {
  console.log("made request " + requestCounter++);
  request(useIP ? "54.175.219.8/get" : "http://httpbin.org/get", function (error, response, body) {
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
