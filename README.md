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

See [test suite]() for more code samples.

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
