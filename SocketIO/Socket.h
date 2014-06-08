//
//  Socket.h
//  SocketIO
//
//  Created by Hao-kang Den on 6/7/14.
//
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <Foundation/Foundation.h>
#import "Emitter+Blocks.h"

typedef void (^SocketIOAck)(NSArray *response);

//   Objective-C type  |   JavaScript type
// --------------------+---------------------
//         nil         |     undefined
//        NSNull       |        null
//       NSString      |       string
//       NSNumber      |   number, boolean
//     NSDictionary    |   Object object
//       NSArray       |    Array object
//        NSDate       |     Date object
//       NSBlock *     |   Function object *
//          id **      |   Wrapper object **
//        Class ***    | Constructor object ***

@interface Socket : NSObject

@property (nonatomic, readonly) BOOL connected;

- (id) initWithSocket:(JSValue *)socket;
- (void) emit:(id)event, ... NS_REQUIRES_NIL_TERMINATION;

@end
