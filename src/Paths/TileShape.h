//
//  Tile.h
//  Paths
//
//  Created by Colin Milhench on 07/02/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TileShape : SKShapeNode

@property(nonatomic, assign) int Row;

@property(nonatomic, assign) int Col;

@property(nonatomic, assign) int Hit;

@property(nonatomic, assign) int Cat;

@end
