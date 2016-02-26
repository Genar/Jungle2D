//
//  Tile.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "Tile.h"
#import "ResourceManager.h"

@implementation Tile

@synthesize textureName;
@synthesize frame;

- (Tile *) init
{
	self = [super init];
    if (self)
    {
        flags = 0;
    }
    
	return self;
}

- (Tile *) initWithTexture:(NSString*)texture withFrame:(CGRect) fram
{
	self = [self init];
    if (self)
    {
        textureName = texture;
        frame = fram;
    }
    
	return self;
}

- (void) drawInRect:(CGRect)rect
{
	[[[ResourceManager sharedInstance] getTexture:textureName] drawInRect:rect withClip:frame withRotation:0];
}

- (void) dealloc
{
	[super dealloc];
}
@end
