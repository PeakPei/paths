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
#import "SKNode+DebugDraw.h"

@implementation MyScene {
    CGMutablePathRef _path;
    TileMapLayer *_layer;
    SKShapeNode *_line;
    SKLabelNode *_label1;
    SKLabelNode *_label2;
    NSMutableArray *_nodes;
    int _worlds;
    int _levels;
    int _world;
    int _level;
    int _score;
    int _target;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _worlds = 2;
        _levels = 10;
        _world = 1;
        _level = 1;
        [self initializeSceneWithWorld:_world Level:_level];
    }
    return self;
}

- (void)clearScene {
//    [self enumerateChildNodesWithName:@"level" usingBlock:^(SKNode *node, BOOL *stop) {
//        [node removeFromParent];
//    }];
//    [self enumerateChildNodesWithName:@"hud1" usingBlock:^(SKNode *node, BOOL *stop) {
//        [node removeFromParent];
//    }];
    [self removeAllChildren];
}
- (void)initializeSceneWithWorld:(int)world Level:(int)level {
    [self clearScene];
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    NSLog(@"Loading: level%d-%d.txt", world, level);
    _layer = [TileMapLayer tileMapLayerFromFileNamed:[NSString stringWithFormat:@"level%d-%d.txt", world, level]];
    _layer.name = @"level";
    _layer.zPosition = 100;
    [self addChild:_layer];
    
    _target += _layer.Target;
    
    _label1 = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
    _label1.name = @"hud1";
    _label1.text = [NSString stringWithFormat:@"%d/%d", 0, _layer.Target];
    _label1.fontSize = 24;
    _label1.fontColor = [SKColor blackColor];
    _label1.position = CGPointMake(self.size.width / 2, self.size.height - 32);
    [self addChild:_label1];
    
    _label2 = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
    _label2.name = @"hud2";
    _label2.text = [NSString stringWithFormat:@"%d/%d", _score, _target];
    _label2.fontSize = 24;
    _label2.fontColor = [SKColor blackColor];
    _label2.position = CGPointMake(self.size.width / 2, 8);
    [self addChild:_label2];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = (SKNode *)[self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"spot"]) {
        TileShape * tile = (TileShape *)node.parent;
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
    
    if ([node.name isEqualToString:@"spot"]) {
        TileShape * tile = (TileShape *)node.parent;
        
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
                [_nodes removeLastObject];
            } else {
                // TODO: JUICE : Light node
                // TODO: JUICE : Play sound
                if (tile.Hit > 0) {
                    tile.Hit--;
                    [_nodes addObject: tile];
                }
            }
            _label1.text = [NSString stringWithFormat:@"%d/%d", _nodes.count, _layer.Target];
            _label2.text = [NSString stringWithFormat:@"%d/%d", _score + _nodes.count, _target];
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
        _score += _nodes.count;
        _label2.text = [NSString stringWithFormat:@"%d/%d", _score, _target];
        NSLog(@"Scored: %d/%d", _score, _target);
        if (_level < _levels) {
            _level +=1;
        } else {
            _world+= 1;
            _level = 1;
        }
        [self clearScene];
        if (_world <= _worlds) {
            [self initializeSceneWithWorld:_world Level:_level];
        }
    } else {
        [self clearScene];
        [self initializeSceneWithWorld:_world Level:_level];
    }
    while (_nodes.count) {
        [_nodes removeLastObject];
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
