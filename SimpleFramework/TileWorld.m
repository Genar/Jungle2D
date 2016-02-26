//
//  TileWorld.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//


#import "TileWorld.h"
#import "Tile.h"
#import "Sprite.h"
#import "ResourceManager.h"
#import "Entity.h"
#import "PointMath.h"

@implementation TileWorld

@synthesize world_width;
@synthesize world_height;

- (void) allocateWidth:(int)width height:(int)height
{
	world_width = width;
	world_height = height;
	tiles = (Tile***) malloc(width*sizeof(Tile**));
	for (int x = 0; x < width; x++)
    {
		tiles[x] = (Tile**) malloc(height*sizeof(Tile*));
		for(int y = 0; y < height; y++)
        {
			tiles[x][y] = [[Tile alloc] init];
		}
	}
}

- (TileWorld *) initWithFrame:(CGRect) frame
{
	self = [super init];
    if (self)
    {
        view = frame;
    }
    
	return self;
}

- (void) draw
{
	CGFloat xoff = -camera_x + view.origin.x + view.size.width/2;
	CGFloat yoff = -camera_y + view.origin.y + view.size.height/2;
	CGRect rect = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
	for(int x = 0; x < world_width; x++)
    {
		rect.origin.x = x * TILE_SIZE + xoff;
        
		//optimization: don't draw offscreen tiles.  only useful when world is much larger than screen, which our emu level happens to be.
		if(rect.origin.x + rect.size.width < view.origin.x || rect.origin.x > view.origin.x + view.size.width)
        {
			continue;
		}
		
		for(int y = 0; y < world_height; y++)
        {
			rect.origin.y = y * TILE_SIZE + yoff;
			if(rect.origin.y + rect.size.height < view.origin.y || rect.origin.y > view.origin.y + view.size.height)
            {
				continue;
			}
			[tiles[x][y] drawInRect:rect];
		}
	}
	if (entities)
    {
		[entities sortUsingSelector:@selector(depthSort:)];
		for(Entity *entity in entities)
        {
			[entity drawAtPoint:CGPointMake(xoff, yoff)];
		}
	}
}

- (void) setCamera:(CGPoint)position
{
	camera_x = position.x;
	camera_y = position.y;
	if (camera_x < 0 + view.size.width/2)
    {
		camera_x = view.size.width/2;
	}
	if (camera_x > TILE_SIZE*world_width - view.size.width/2)
    {
		camera_x = TILE_SIZE*world_width - view.size.width/2;
	}
	if (camera_y < 0 + view.size.height/2)
    {
		camera_y = view.size.height/2;
	}
	if (camera_y > TILE_SIZE*world_height - view.size.height/2)
    {
		camera_y = TILE_SIZE*world_height - view.size.height/2;
	}
}

- (void) loadLevel:(NSString *)levelFilename withTiles:(NSString *)imageFilename
{
	NSData *filedata = [[ResourceManager sharedInstance] getBundleData:levelFilename];
	NSString *dush = [[NSString alloc] initWithData:filedata encoding:NSASCIIStringEncoding];
	
	//expected format:
	//widthxheight, ie 15x25.  whitespace is ok, 15 x 25.
	//[height] rows of [width] comma-separated tile indexes.
	//a blank row, for sanity's sake.
	//[height] rows of [width] comma-separated physics flags.
	
	NSArray *rows = [dush componentsSeparatedByString:@"\n"];
	int rowindex = 0;
	NSArray* wh = [[rows objectAtIndex:rowindex] componentsSeparatedByString:@"x"];
	int width = [[wh objectAtIndex:0] intValue];
	int height = [[wh objectAtIndex:1] intValue];
	[self allocateWidth:width height:height];
	rowindex++;
	
#if DEBUG
    NSLog(@"<%p %@: %s line:%d>  Load level dim %dx%d", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, width, height);
#endif
    
	for(int y = 0; y < world_height; y++)
    {
		NSArray *row = [[rows objectAtIndex:rowindex] componentsSeparatedByString:@","];
		for(int x = 0; x < world_width; x++)
        {
			int tile = [[row objectAtIndex:x] intValue];
			int tx = (tile * (int)TILE_SIZE) % 1024;
			int row = (( tile * TILE_SIZE ) - tx) / 1024;
			int ty = row * TILE_SIZE;
			[tiles[x][world_height-y-1] initWithTexture:imageFilename withFrame:CGRectMake(tx, ty, TILE_SIZE, TILE_SIZE)];
		}
		rowindex++;
	}
	rowindex++;
	for(int y = 0; y < world_height; y++)
    {
		NSArray *row = [[rows objectAtIndex:rowindex] componentsSeparatedByString:@","];
		for(int x = 0; x < world_width; x++)
        {
			int flags = [[row objectAtIndex:x] intValue];
			tiles[x][world_height-y-1]->flags = (PhysicsFlags) flags;
		}
		rowindex++;
	}
	[dush release];
}

- (void) addEntity:(Entity*) entity
{
	if(!entities) entities = [[NSMutableArray alloc] init];
	[entity setWorld:self];
	[entities addObject:entity];
}

- (void) removeEntity:(Entity*) entity
{
	[entities removeObject:entity];
}

//used when tapping an area of the screen to move the player.
- (CGPoint) worldPosition:(CGPoint)screenPosition
{
	CGFloat xoff = camera_x + view.origin.x - view.size.width/2;
	CGFloat yoff = camera_y + view.origin.y - view.size.height/2;
	return CGPointMake(xoff + screenPosition.x, yoff + screenPosition.y);
}

//used by entities to get the tile they are standing over.
- (Tile *) tileAt:(CGPoint)worldPosition
{
	int x = worldPosition.x / TILE_SIZE; //...should be floor.
	int y = worldPosition.y / TILE_SIZE;
	//note that x and y are slightly wrong when negative and near zero, because [-TILE_SIZE..TILESIZE]/TILESIZE == 0, even though [-TILESIZE..0) would be considered out of bounds.
	if(worldPosition.x < 0 || worldPosition.y < 0 || x >= world_width || y >= world_height)
    {
#if DEBUG
        NSLog(@"<%p %@: %s line:%d>  Tile at point %d,%d outside of world dimensions %d,%d", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, x, y, world_width, world_height);
#endif
		return nil;
	}
    
	return tiles[x][y];
}

- (BOOL) walkable:(CGPoint) point
{
	Tile* overtile = [self tileAt:point];
	return !(overtile == nil || (overtile->flags & UNWALKABLE) != 0);
}

//used in croc level to figure out what our player can jump to.
- (NSArray*) entitiesNear:(CGPoint) point withRadius:(float) radius
{
	NSMutableArray* retval = [NSMutableArray array];
	radius = radius * radius; //for distsquared comparison.
	for(Entity* e in entities)
    {
		if(distsquared(e.position, point) < radius)
        {
			[retval addObject:e];
		}
	}
    
	return retval;
}

- (void) dealloc
{
	for(int x = 0; x < world_width; x++)
    {
		for(int y = 0; y< world_height; y++)
        {
			[tiles[x][y] release];
		}
		free (tiles[x]);
	}
	free (tiles);
	[entities removeAllObjects];
	[entities release];
	[super dealloc];
}

@end
