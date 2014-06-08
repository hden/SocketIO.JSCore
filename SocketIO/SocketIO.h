//
//  SocketIO.h
//  SocketIO
//
//  Created by Hao-kang Den on 6/7/14.
//
//

#import <Foundation/Foundation.h>
#import "Emitter+Blocks.h"
#import "Socket.h"

@interface SocketIO : NSObject

- (Socket *)of:(NSString *)url and:(NSDictionary *)options;

@end
