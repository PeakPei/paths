//
//  SKNode+DebugDraw.h
//  Paths
//
//  Created by Colin Milhench on 24/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (DebugDraw)

- (void)attachDebugRectWithSize:(CGSize)size;
- (void)attachDebugFrameFromPath:(CGPathRef)path;

@end
