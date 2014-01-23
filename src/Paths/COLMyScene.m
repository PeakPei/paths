//
//  COLMyScene.m
//  Paths
//
//  Created by Colin Milhench on 17/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import "COLMyScene.h"
#import "COLTileMapLayer.h"

@implementation COLMyScene {
    CGMutablePathRef _path;
    SKShapeNode *_line;
    NSMutableArray *_nodes;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //*
        COLTileMapLayer *layer = [COLTileMapLayer tileMapLayerFromFileNamed:@"level3.txt"];
        [self addChild:layer];
        //*/
        /*
        SKSpriteNode *tile;
        for (int y = 0; y < 15; y++) {
            for (int x = 0; x < 20; x++) {
                tile = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
                tile.name = @"dot";
                tile.position = CGPointMake(48+(48*x), 718-(48*y));
                tile.color = [SKColor colorWithRed:0x39/255.0 green:0xCC/255.0 blue:0xCC/255.0 alpha:1.0];
                tile.colorBlendFactor = 1;
                tile.size = CGSizeMake(20,20);
                tile.zPosition = 100;
                tile.speed = (y*20+x);
                [self addChild:tile];
            }
        }
        //*/
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if (![[node name] isEqualToString:@"dot"]) {
        return;
    }
    NSLog(@"Touched: %f %f", node.speed, node.zPosition);
    
    _nodes = [NSMutableArray arrayWithObjects:node, nil];
    
    // TODO: JUICE : Light node
    // TODO: JUICE : Play sound
    
    _line = [SKShapeNode node];
    _line.strokeColor = [SKColor colorWithRed:0xFF/255.0 green:0x41/255.0 blue:0x36/255.0 alpha:0.6];
    _line.lineWidth = 6;
    _line.zPosition = 0;
    [self addChild:_line];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if (_nodes.count == 0) {
        return;
    }
    NSLog(@"Over: %f %f", node.speed, node.zPosition);
    
    /* restrict to: up,down,left,right*/
    SKSpriteNode *prev = [_nodes objectAtIndex: _nodes.count-1];
    if (node.speed != prev.speed+1 &&
        node.speed != prev.speed-1 &&
        node.speed != prev.speed-20 &&
        node.speed != prev.speed+20) {
        node = nil;
    }
    
    if ([node.name isEqualToString:@"dot"]) {
        // TODO: pop off the previous node if backtracking
        // TODO: JUICE : Light node (unlight if backtracking)
        // TODO: JUICE : Play sound
        [_nodes addObject: node];
    }
    
    [self updatePath:location];
    _line.path = _path;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _nodes = [NSMutableArray arrayWithObjects:nil];
    [_line removeFromParent];
    CGPathRelease(_path);
    // TODO: calculate score
    // TODO: move to next puzzle if solved
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)updatePath:(CGPoint)end {
    SKSpriteNode *node;
    _path = CGPathCreateMutable();
    if (_nodes.count == 0) {
        return;
    }
    node = [_nodes objectAtIndex: 0];
    CGPathMoveToPoint(_path, NULL, node.position.x, node.position.y);
    for (int i = 0; i < _nodes.count; i++) {
        node = [_nodes objectAtIndex: i];
        CGPathAddLineToPoint(_path, NULL, node.position.x, node.position.y);
    }
    CGPathAddLineToPoint(_path, NULL, end.x, end.y);
}

@end
