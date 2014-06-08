SocketIO.JSCore
===============

SocketIO v1.0.x via JavaScriptCore

Why?
----

Socket.IO v1.0.0 is a major refactoring of the popular real-time framework.
Unfortunatelly the communication protocal has changed drastically, thus
most of the existing obj-c library won't work with v1.0.x.

This project is aimed for a obj-c bridge to the official framework via JavaScriptCore.

Design
------

    ------------------------------
    |      socket.io obj-c       |
    ------------------------------
                ⬆ ⬇
    ------------------------------
    | UIWebView + JavaScriptCore |
    ------------------------------
                ⬆ ⬇
    ------------------------------
    |    socket.io JavaScript    |
    ------------------------------

Usage
-----

    #import "SocketIO.h"

    // This library is heavily inspired by the event emitter API of the official client
    // Both SocketIO and Socket class are event emitter.
    SocketIO *io = [[SocketIO alloc] init];

    [io once:@"ready" listener:^{
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        [socket once:@"hi" listener:^{
            // recieved response from server
        }];
        [socket emit:@"hi", nil];

        [socket emit:@"giveMeDataViaAck", @{@"test": @true}, ^(id *data) {
            // got response
        }, nil];
    }];

See [test suite](https://github.com/hden/SocketIO.JSCore/blob/master/Tests/DemoAppTests/DemoAppTests.m) for more code samples.

Further Readings
----------------

* [JavaScript] [official documentation](http://socket.io/docs/)
* [JavaScript] [node.js event emitter](http://nodejs.org/api/events.html)
* [Obj-c] [event emitter](https://github.com/seegno/emitter-objc)

Development
-----------

    cd Test
    npm install
    pod install
    open ../SocketIO.xcworkspace
    npm start

Licence
-------

MIT
