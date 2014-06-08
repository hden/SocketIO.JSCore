//
//  SocketIO.m
//  SocketIO
//
//  Created by Hao-kang Den on 6/7/14.
//
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SocketIO.h"

@interface SocketIO()<UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;
@property (nonatomic) JSContext *context;
@property (nonatomic) JSValue *io;

@end

@implementation SocketIO

- (id) init
{
    self = [super init];
    if (self) {
        NSString *bundlePath = [[NSBundle bundleForClass:[SocketIO class]] pathForResource:@"SocketIO" ofType:@"bundle"];
        NSURL *url           = [[NSBundle bundleWithPath:bundlePath] URLForResource:@"index" withExtension:@"html"];
        NSString *src        = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        _webView             = [[UIWebView alloc] init];
        _webView.delegate    = self;
        
        [_webView loadHTMLString:src baseURL:nil];
        
        _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        __block __weak SocketIO *this = self;
        _context[@"window"][@"onload"] = ^{
            [this onReady];
        };
        
        [_context setExceptionHandler:^(JSContext *ctx, JSValue *val) {
            NSLog(@"error %@", val);
            NSDictionary *info = @{@"context": ctx, @"value": val};
            NSError *error     = [NSError errorWithDomain:@"SocketIO" code:0 userInfo:info];
            [this emit:@"error", error];
        }];
    }
    return self;
}

- (Socket *) of:(NSString *)url and:(NSDictionary *)options
{
    JSValue *socket = [_io callWithArguments:@[url, options]];
    return [[Socket alloc] initWithSocket:socket];
}

- (void) onReady
{
    NSLog(@"ready");
    self.io = self.context[@"io"];
    [self emit:@"ready"];
}

@end
