//
//  Lion.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "Lion.h"
#import "Sprite.h"
#import "ResourceManager.h"
#import "TileWorld.h"
#import "Tile.h"
#import "PointMath.h"

@implementation Lion

- (NSString *) animForState:(LionState)lionState
{
	NSString *states[] = {
		@"asleep",
		@"waking",
		@"alert",
		@"attacking",
	};
	NSString *states_flip[] = {
		@"asleep-flip",
		@"waking-flip",
		@"alert-flip",
		@"attacking-flip",
	};
    
	return (flip ? states_flip : states)[lionState];
}

- (void) setState:(LionState) lionState
{
	state = lionState;
	sprite.sequence = [self animForState:lionState];
	state_time = 0;
	m_rage = 0;
	if(state == ATTACKING)
    {
		[[ResourceManager sharedInstance] playSound:@"tap.caf"];
	}
}

- (id) initWithPos:(CGPoint) pos sprite:(Sprite*)spr facingLeft:(bool)faceleft
{
	self = [super initWithPos:pos sprite:spr];
    if (self)
    {
        flip = !faceleft;
        [self setState:ASLEEP];
    }
    
	return self;
}

- (void) update:(CGFloat) time
{
	state_time += time;
	switch (state) {
		case ASLEEP:
			//5 times a second, take a 2% chance to wake up.
			if(state_time > 0.2f)
            {
				if(random() % 1000 < 20)
                {
					[self setState:WAKING];
				}
                else
                {
					state_time = 0;
				}
			}
			break;
            
		case WAKING:
			if(state_time > 0.2f)
            {
				if(random() % 1000 < 20)
                {
					[self setState:ALERT];
				}
                else if(random() % 1000 < 20)
                {
					[self setState:ASLEEP];
				}
                else
                {
					state_time = 0;
				}
			}
			break;
            
		case ALERT:
			if(state_time > 2.0f && m_rage == 0)
            {
				[self setState:WAKING];
			}
			break;
            
		case ATTACKING:
			if(state_time > 2.0f && m_rage == 0)
            {
				[self setState:ALERT];
			}
			break;
            
		default:
			break;
	}
	[sprite update:time];
}

//called in main game loop so we can react to the player's movement
- (bool) wakeAgainst:(Entity *) other
{
	//each state has a different triggering radius... you can get closer to sleeping lions, and should stay further from alert lions.
	float vision[] = { TILE_SIZE, TILE_SIZE * 2, TILE_SIZE * 3, TILE_SIZE * 3, };
	float dist = distsquared(self.position, other.position);
	if(dist < vision[state]*vision[state])
    {
		m_rage++;
	}
    else
    {
		m_rage--;
		if(m_rage < 0) m_rage = 0;
	}
	
	//how much rage is needed to advance to the next rage state
	int ragemax[] = { 1, 20, 20, 20, };
	
	if(m_rage > ragemax[state])
    {
		if(state == ATTACKING)
        {
			m_rage = ragemax[state];
			//can't rage more.
		}
        else
        {
			[self setState:state+1];
		}
	}
	
	//attack hit detection against the player.
	if(state == ATTACKING)
    {
		CGPoint attackoffset = CGPointMake(-TILE_SIZE, 0);
		if(flip)
        {
			attackoffset.x = - attackoffset.x;
		}
		attackoffset = add(worldPos, attackoffset);
		float dist = distsquared(attackoffset, other.position);
		if(dist < 32 * 32)
        {
			return true;
		}
	}
	return false;
}

- (void) obstruct
{
	Tile *t = [world tileAt:worldPos];
	t->flags |= UNWALKABLE;
	t = [world tileAt:CGPointMake(worldPos.x - TILE_SIZE, worldPos.y)];
	t->flags |= UNWALKABLE;
}

@end
