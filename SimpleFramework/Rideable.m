//
//  Rideable.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "Rideable.h"
#import "Sprite.h"
#import "TileWorld.h"

@implementation Rideable

- (id) initWithPos:(CGPoint) pos sprite:(Sprite *)spr
{
	self = [super initWithPos:pos sprite:spr];
    if (self)
    {
        bounds = CGRectMake(-57, -17, 113, 17);
        //log-specific.  should probably be moved to animation.plist and Animation or Sprite.
    }
    
	return self;
}

- (bool) under:(CGPoint)point
{
	if(
	   point.x > self.position.x + bounds.origin.x &&
	   point.x < self.position.x + bounds.origin.x + bounds.size.width &&
	   point.y > self.position.y + bounds.origin.y &&
	   point.y < self.position.y + bounds.origin.y + bounds.size.height
	   ) return true;
	return false;
}

- (void) update:(CGFloat) time
{
	if(m_rider && [sprite.sequence isEqualToString:@"sinking"])
    {
		if(sprite.currentFrame > sunkframe)
        {
			sunkframe = sprite.currentFrame;
			int sinkoffset[] = {1,9,5,5,8};
			[m_rider forceToPos:CGPointMake(m_rider.position.x, m_rider.position.y - sinkoffset[sunkframe])];
		}
	}
	[super update:time];
}

- (void) drawAtPoint:(CGPoint) offset
{
	if([sprite.sequence isEqualToString:@"sunk"]) return;
	[super drawAtPoint:offset];
}

- (void) markRidden:(Entity*) rider
{
	m_rider = rider;
	sunkframe = 0;
	if(rider)
    {
		sprite.sequence = @"sinking";
	}
    else
    {
		sprite.sequence = @"rising";
	}
}

@end
