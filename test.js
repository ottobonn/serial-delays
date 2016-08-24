var request = require("request");
var serialport = require("serialport");
var SerialPort = serialport.SerialPort;

var reqCounter = 0;
var respCounter = 0;

function makeRequest() {
  console.log("make request " + reqCounter++);
  request("http://httpbin.org/get", function (error, response, body) {
    console.log("response " + respCounter++);
    //console.log(error);
    //console.log(body);
  });
}

var port;
serialport.list(function (error, ports) {
  console.log(ports);
  var comName = ports[0].comName;
  console.log("port name: "+ comName);
  port = new SerialPort(comName);
  port.on("open", function() {
    console.log("Port open");
    counter = 0;
    setInterval(function () {
      console.log("tick " + counter++);
    }, 1000);
    port.write("!");
    console.log("Write ! reset");
    port.on("data", function (data) {
      var string = data.toString();
      console.log("data: " + string);
      console.log("Write C");
      port.write("C");
      makeRequest();
    });
  });
});
