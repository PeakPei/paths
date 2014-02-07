//
//  MyScene.m
//  Paths
//
//  Created by Colin Milhench on 17/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import "MyScene.h"
#import "TileMapLayer.h"
#import "TileShape.h"

@implementation MyScene {
    CGMutablePathRef _path;
    TileMapLayer *_layer;
    SKShapeNode *_line;
    NSMutableArray *_nodes;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initializeScene];
    }
    return self;
}

- (void)initializeScene {
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    _layer = [TileMapLayer tileMapLayerFromFileNamed:@"level3.txt"];
    _layer.zPosition = 100;
    [self addChild:_layer];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"dot"]) {
        
        TileShape * tile = (TileShape *)node;
        if (tile.Cat != 's') return;
        
        tile.Hit--;
        _nodes = [NSMutableArray arrayWithObjects:tile, nil];
        
        // TODO: JUICE : Light node
        // TODO: JUICE : Play sound
        
        _line = [SKShapeNode node];
        _line.strokeColor = [SKColor colorWithRed:0xFF/255.0 green:0x41/255.0 blue:0x36/255.0 alpha:0.6];
        _line.lineWidth = 6;
        _line.zPosition = 10;
        [self addChild:_line];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    //NSLog(@"Over: %d %f %f", _nodes.count, node.speed, node.zPosition);
    if (_nodes.count == 0) {
        return;
    }
    
    if ([node.name isEqualToString:@"dot"]) {
        TileShape * tile = (TileShape *)node;
        
        // restrict to: up,down,left,right
        TileShape *last = [_nodes objectAtIndex: _nodes.count-1];
        
        if ((tile.Row == last.Row && labs(tile.Col - last.Col) == 1) ||
            (tile.Col == last.Col && labs(tile.Row - last.Row) == 1)) {
            
            // pop off the previous node if backtracking
            TileShape *prev;
            if (_nodes.count > 1) prev = [_nodes objectAtIndex: _nodes.count-2];
            if (prev && tile == prev){
                // TODO: JUICE : Play sound
                last.Hit++;
                [_nodes removeObject:last];
            } else {
                // TODO: JUICE : Light node
                // TODO: JUICE : Play sound
                if (tile.Hit > 0) {
                    tile.Hit--;
                    [_nodes addObject: tile];
                }
            }
        }
    }
    
    [self updatePath:location];
    _line.path = _path;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    TileShape *node;
    if (_nodes.count == 0) {
        return;
    }
    
    node = [_nodes lastObject];
    if (node.Cat == 'e') {
        // TODO: calculate score
        // TODO: move to next puzzle if solved
        NSLog(@"Scored: %d/%d", _nodes.count, _layer.Target);
    };
    
    while (_nodes.count) {
        node = [_nodes lastObject];
        node.Hit = 1;
        [_nodes removeObject:node];
    }
    CGPathRelease(_path);
    _path = 0;
    [_line removeFromParent];
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
    CGPathMoveToPoint(_path, NULL, node.position.x+32, node.position.y+32);
    for (int i = 0; i < _nodes.count; i++) {
        node = [_nodes objectAtIndex: i];
        CGPathAddLineToPoint(_path, NULL, node.position.x+32, node.position.y+32);
    }
    CGPathAddLineToPoint(_path, NULL, end.x, end.y);
}

@end
