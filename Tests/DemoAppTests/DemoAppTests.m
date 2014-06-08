//
//  DemoAppTests.m
//  DemoAppTests
//
//  Created by Hao-kang Den on 6/8/14.
//  Copyright (c) 2014 Den & Friends. All rights reserved.
//

#define EXP_SHORTHAND

#import <XCTest/XCTest.h>
#import "Specta.h"
#import "Expecta.h"
#import "OCMock.h"
#import "SocketIO.h"

SpecBegin(SocketIO)

describe(@"socket.io connection", ^{
    __block SocketIO *io;
    __block dispatch_queue_t mq = dispatch_get_main_queue();
    setAsyncSpecTimeout(10);
    
    beforeAll(^AsyncBlock {
        io = [[SocketIO alloc] init];
        [io once:@"ready" listener:done];
        
    });
    
    it(@"should connect to localhost", ^AsyncBlock {
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        [socket once:@"hi" listener:^{
            done();
        }];
        [socket emit:@"hi", nil];
    });
    
    it(@"should work with acks", ^AsyncBlock {
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        [socket once:@"ack" listener:^(SocketIOAck fn) {
            fn(@[@5, @{@"test": @true}]);
        }];
        [socket once:@"got it" listener:done];
        [socket emit:@"ack", nil];
    });
    
    it(@"should receive date with ack", ^AsyncBlock {
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        
        [socket emit:@"getAckDate", @{@"test": @true}, ^(NSString *data) {
            dispatch_async(mq, ^{
                expect(data).to.beKindOf([NSString class]);
                done();
            });
        }, nil];
    });
    
    it(@"should work with false", ^AsyncBlock {
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        [socket once:@"false" listener:^(id f) {
            dispatch_async(mq, ^{
                expect(f).to.beFalsy();
                done();
            });
        }];
        [socket emit:@"false", nil];
    });
    
    it(@"should receive utf8 multibyte characters", ^AsyncBlock {
        Socket *socket = [io of:@"http://localhost:8000" and:@{}];
        NSArray *correct = @[@"てすと", @"Я Б Г Д Ж Й", @"Ä ä Ü ü ß", @"utf8 — string", @"utf8 — string"];
        __block int i = 0;
        [socket on:@"takeUtf8" listener:^(NSString *data) {
            dispatch_async(mq, ^{
                expect(data).to.equal(correct[i]);
                i++;
                if (i == correct.count) {
                    done();
                }
            });
        }];
        [socket emit:@"getUtf8", nil];
    });
});

SpecEnd