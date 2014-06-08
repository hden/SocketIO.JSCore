//
//  Socket.m
//  SocketIO
//
//  Created by Hao-kang Den on 6/7/14.
//
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "Socket.h"

@interface Socket()

@property (nonatomic) JSValue *socket;
@property (nonatomic) NSMutableArray *buffer;

@end

@implementation Socket

- (id) initWithSocket:(JSValue *)socket
{
    self = [super init];
    if (self) {
        _socket    = socket;
        _connected = false;
        _buffer    = @[].mutableCopy;
        
        // event delegation
        __block __weak Socket *this = self;
        [_socket invokeMethod:@"on" withArguments:@[@"connect", ^{
            [this onconnect];
        }]];
        
        [_socket invokeMethod:@"on" withArguments:@[@"disconnect", ^{
            [this ondisconnect];
        }]];
        
        [_socket invokeMethod:@"on" withArguments:@[@"error", ^(id reason) {
            [this onerror:reason];
        }]];
        
        _socket[@"onevent"] = ^(NSDictionary *packet) {
            [this onevent:packet];
        };
    }
    return self;
}

- (void) onconnect
{
    _connected = true;
    [super emit:@"connect"];
    
    // emit buffered events.
    for (NSDictionary *packet in self.buffer) {
        [self onevent:packet];
    }
}

- (void) ondisconnect
{
    _connected = false;
    [super emit:@"disconnect"];
}

- (void) onerror:(id)reason
{
    NSError *error = [NSError errorWithDomain:@"socket.io" code:0 userInfo:@{@"reason": reason}];
    [super emit:@"error", error];
}

- (void) onevent:(NSDictionary *)packet
{
    NSMutableArray *args;
    if (packet[@"data"] != nil) {
        args = packet[@"data"];
    } else {
        args = @[].mutableCopy;
    }
    
    if (packet[@"id"] != nil) {
        [args addObject:[self ack:packet[@"id"]]];
    }
    
//    if (self.connected) {
//        id eventName = args[0];
//        [args removeObjectAtIndex:0];
//        [super emit:eventName args:args];
//    } else {
//        [self.buffer addObject:packet];
//    }
    id eventName = args[0];
    [args removeObjectAtIndex:0];
    [super emit:eventName args:args];
}

- (SocketIOAck) ack:(id)ackid
{
    __block JSValue *ack = [self.socket invokeMethod:@"ack" withArguments:@[ackid]];
    
    SocketIOAck cb = ^(NSArray *response) {
        [ack callWithArguments:response];
    };
    
    return cb;
}

- (void)emit:(id)event, ...
{
    if (event == nil) {
        return;
    }
    
    NSMutableArray *arguments = @[].mutableCopy;
    va_list args;
    va_start(args, event);
    
    for (id param = event; param != nil; param = va_arg(args, id)) {
        [arguments addObject:param];
    }
    
    va_end(args);

    [self.socket invokeMethod:@"emit" withArguments:arguments];
}

- (void) dealloc
{
    [_socket invokeMethod:@"removeAllListeners" withArguments:nil];
    [self removeAllListeners];
}

@end
