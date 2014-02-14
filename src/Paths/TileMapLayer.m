//
//  TileMapLayer.m
//  Paths
//
//  Created by Colin Milhench on 17/01/2014.
//  Copyright (c) 2014 Colin Milhench. All rights reserved.
//

#import "TileMapLayer.h"
#import "TileShape.h"

/* Constants.h */

#define CarminePink [SKColor colorWithRed:0xEB/255.0 green:0x5C/255.0 blue:0x40/255.0 alpha:1.0]
#define LightGreen [SKColor colorWithRed:0x85/255.0 green:0xEA/255.0 blue:0x8A/255.0 alpha:1.0]

#define MayaBlue [SKColor colorWithRed:0x87/255.0 green:0xB9/255.0 blue:0xFF/255.0 alpha:1.0]
#define Peridot [SKColor colorWithRed:0xE8/255.0 green:0xDD/255.0 blue:0x00/255.0 alpha:1.0]
#define DeepLilac [SKColor colorWithRed:0x99/255.0 green:0x5A/255.0 blue:0xB7/255.0 alpha:1.0]

#define LilyWhite [SKColor colorWithRed:0xEA/255.0 green:0xEB/255.0 blue:0xEA/255.0 alpha:1.0]
#define AntiFlashWhite [SKColor colorWithRed:0xF5/255.0 green:0xF3/255.0 blue:0xF1/255.0 alpha:1.0]

#define TileSize CGRectMake(0, 0, 64, 64)
#define DotSize CGRectMake(16, 16, 32, 32)

static NSString *BKSNodeNameSpot   = @"spot";
static NSString *BKSNodeNameTile   = @"tile";

//typedef NS_ENUM(uint16_t, BKSCategory)
//{
//    BKSCategoryBall   = 1 << 1
//};


@implementation TileMapLayer {
    CGSize _size;
}

+ (TileMapLayer *)tileMapLayerFromFileNamed:(NSString *)fileName
{
    // file must be in bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
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
    // lines are the grid. It's assumed that all rows are same length
    NSArray *grid = [lines subarrayWithRange:NSMakeRange(0, lines.count)];
    
    return [[TileMapLayer alloc] initWithGrid:grid];
}

- (instancetype)initWithGrid:(NSArray *)grid;
{
    if (self = [super init])
    {
        _size = CGSizeMake(0, 0);
        _size.height = grid.count*TileSize.size.height;
        for (int y = 0; y < grid.count; y++) {
            NSString *line = grid[y];
            _size.width = line.length*TileSize.size.width;
            for(int x = 0; x < line.length; x++) {
                unichar chr = [line characterAtIndex:x];
                TileShape *tile = [self tileForCharacter:chr];
                if (tile != nil) {
                    tile.Row = y;
                    tile.Col = x;
                    tile.position = [self positionForX:x andY:y];
                    [self addChild:tile];
                }
            }
        }
    }
    return self;

}

- (TileShape*)tileForCharacter:(unichar)chr
{
    if (chr == '.') { return nil; }
    
    // create an ellipse arround the centre
    //CGPathRef path = CGPathCreateWithEllipseInRect(DotSize, nil);
    
    TileShape *tile = [TileShape node];
    tile.name = BKSNodeNameTile;
    
    //tile.path = path;
    tile.Cat = chr;
    switch (chr) {
        case 's':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            [tile addChild:[self dotWithSize:32 andColor:CarminePink]];
            tile.Hit = 1;
            break;
        case 'e':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            [tile addChild:[self dotWithSize:32 andColor:LightGreen]];
            tile.Hit = 1;
            break;
        case '0':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            tile.Hit = 0;
            break;
        case '1':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            [tile addChild:[self dotWithSize:32 andColor:MayaBlue]];
            tile.Hit = 1;
            break;
        case '2':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            [tile addChild:[self dotWithSize:32 andColor:MayaBlue]];
            [tile addChild:[self dotWithSize:24 andColor:DeepLilac]];
            tile.Hit = 2;
            break;
        case '3':
            [tile addChild:[self dotWithSize:32 andColor:AntiFlashWhite]];
            [tile addChild:[self dotWithSize:32 andColor:MayaBlue]];
            [tile addChild:[self dotWithSize:24 andColor:DeepLilac]];
            [tile addChild:[self dotWithSize:16 andColor:Peridot]];
            tile.Hit = 3;
            break;
    }
    //CGPathRelease(path);
    
    // keep a count of all visible nodes
    self.Target += tile.Hit;
    
    return tile;
}

- (SKShapeNode*)dotWithSize:(int)size andColor:(SKColor*)color
{
    CGRect rect = CGRectMake(32 - size/2, 32 - size/2, size, size);
    CGPathRef path = CGPathCreateWithEllipseInRect(rect, nil);
    SKShapeNode *node = [SKShapeNode node];
    node.name = BKSNodeNameSpot;
    node.path = path;
    node.fillColor =  color;
    node.strokeColor = color;
    CGPathRelease(path);
    return node;
}

- (CGPoint)positionForX:(NSInteger)x andY:(NSInteger)y
{
    x = (TileSize.size.width*x);
    y = (TileSize.size.height*(y+1));
    return CGPointMake(x, _size.height-y);
}

@end
