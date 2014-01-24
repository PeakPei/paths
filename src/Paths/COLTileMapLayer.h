//
//  COLTileMapLayer.h
//  Paths
//
//  Created by Colin Milhench on 17/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface COLTileMapLayer : SKNode

+ (COLTileMapLayer *)tileMapLayerFromFileNamed:(NSString *)fileName;

- (instancetype)initWithGrid:(NSArray *)grid;

@end
