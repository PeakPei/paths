//
//  TileMapLayer.m
//  Paths
//
//  Created by Colin Milhench on 17/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import "TileMapLayer.h"

@implementation TileMapLayer

+ (TileMapLayer *)tileMapLayerFromFileNamed:(NSString *)fileName
{
    // file must be in bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:nil];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    // if there was an error, there is nothing to be done.
    // Should never happen in properly configured system.
    if (fileContents == nil && error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return nil;
    }
    
    // get the contents of the file, separated into lines
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
    // remaining lines are the grid. It's assumed that all rows are same length
    //NSArray *grid = [lines subarrayWithRange:NSMakeRange(2, lines.count)];
    NSArray *grid = [lines subarrayWithRange:NSMakeRange(0, lines.count)];
    
    return [[TileMapLayer alloc] initWithGrid:grid];
}

- (instancetype)initWithGrid:(NSArray *)grid;
{
    if (self = [super init])
    {
        for (int y = 0; y < grid.count; y++) {
            NSString *line = grid[y];
            for(int x = 0; x < line.length; x++) {
                SKSpriteNode *tile = [self tileForCharacter:[line characterAtIndex:x]];
                if (tile != nil) {
                    tile.name = @"dot";
                    tile.size = CGSizeMake(20,20);
                    tile.zPosition = 100;
                    tile.speed = (y*20+x);
                    tile.position = [self positionForX:x andY:y];
                    [self addChild:tile];
                }
            }
        }
    }
    return self;

}

- (SKSpriteNode*)tileForCharacter:(unichar)chr
{
    SKSpriteNode *tile;
    tile = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
    switch (chr) {
        case '.':
            return nil;
            break;
        case 's':
            tile.color = [SKColor colorWithRed:0x2E/255.0 green:0xCC/255.0 blue:0x40/255.0 alpha:1.0];
            break;
        case 'e':
            tile.color = [SKColor colorWithRed:0xFF/255.0 green:0x41/255.0 blue:0x36/255.0 alpha:1.0];
            break;
        case '1':
            tile.color = [SKColor colorWithRed:0x7F/255.0 green:0xDB/255.0 blue:0xFF/255.0 alpha:1.0];
            break;
        case '2':
            tile.color = [SKColor colorWithRed:0x00/255.0 green:0x74/255.0 blue:0xD9/255.0 alpha:1.0];
            break;
        default:
            NSLog(@"Unknown tile code: %d", chr);
            break;
            
    }
    tile.colorBlendFactor = 1;
    return tile;
}

- (CGPoint)positionForX:(NSInteger)x
                   andY:(NSInteger)y
{
    x = 48+(48*x);
    y = 718-(48*y);
    return CGPointMake(x, y);
}

@end
