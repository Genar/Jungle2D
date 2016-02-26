//
//  EmuLevel.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "EmuLevel.h"
#import "ResourceManager.h"
#import "gsMainMenu.h"
#import "Entity.h"
#import "TileWorld.h"
#import "Sprite.h"
#import "Animation.h"
#import "Emu.h"
#import "EmuMother.h"
#import "Lion.h"
#import "Tile.h"
#import "Tom.h"
#import "PointMath.h"
#import "Crocodile.h"

@interface EmuLevel()
{
	TileWorld *m_tileWorld;
	Tom       *m_tom;
	EmuMother *m_emuMother;
	Emu       * __autoreleasing *m_flock;
	int       flock_len;
    Lion      * __autoreleasing *m_lions;
	int       lions_length;
    Crocodile * __autoreleasing *m_crocodiles;
    int       crocLen;
    Rideable  * __autoreleasing *m_logs;
    int       logLen;
    Entity    * __autoreleasing *m_goals;
    int       goals_count;
    bool      areChicksWithTheirMum;
}
@end

@implementation EmuLevel

- (void) setupWorld
{
    [self setupTileWorld];
    [self setupTom];
    [self setupEmuChick];
    [self setupBigEmu];
    [self setupLions];
    [self setupGoals];    
    [self setupLogs];
    [self setupCrocodiles];
    [self setupBushes];
    [m_tileWorld setCamera:CGPointMake(100, 100)];
	[[ResourceManager sharedInstance] stopMusic];
	[[ResourceManager sharedInstance] playMusic:@"trimsqueak.mp3"];
}

- (void) update
{
	float time = 0.02f;
	[m_tom update:time];
	[m_emuMother update:time];
    [self updateChicks:time];
    [self updateLions:time];
    [self updateGoals:time];
    [self updateLogs:time];
    [self updateCrocodiles:time];
    [self checkTomSunk];
    [self checkEndGame];
	[m_tileWorld setCamera:[m_tom position]];
	[super updateEndgame:time];
}

- (void) render
{
	glClearColor(0xff/256.0f, 0x66/256.0f, 0x00/256.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	[m_tileWorld draw];
	[super renderEndgame];
	//you get white (or black) screen if you forget to swap buffers.
	[self swapBuffers];
}

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager;
{
    self = [super initWithFrame:frame andManager:pManager];
    if (self)
    {
		[self setupWorld];
    }
    
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint touchpos = [m_tileWorld worldPosition:[self touchPosition:touch]];
	float dist = distsquared(touchpos, m_tom.position);
	if (dist < 32 * 32)
    {
		[m_tom jump];
	}
    
	if(![m_tom inJump])
	{
		[m_tom moveToPosition:[m_tileWorld worldPosition:[self touchPosition:touch]]];
	}
    
	[super touchEndgame];
}

- (void) dealloc
{
	[m_tileWorld release];
	[m_tom release];
	[m_emuMother release];
    [self deallocFlock];
    [self deallocLogs];
    [self deallocCrocodiles];
    [self deallocGoals];
    [self deallocLions];
	[super dealloc];
}

- (void) setupTileWorld
{
    m_tileWorld = [[TileWorld alloc] initWithFrame:self.frame];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [m_tileWorld loadLevel:@"level_1_idx_iPad.txt" withTiles:@"level_1_tiles.png"];
    }
    else
    {
        [m_tileWorld loadLevel:@"level_1_idx_iPhone.txt" withTiles:@"level_1_tiles.png"];
    }
}

- (void) setupTom
{
    Animation *tomanim = [[Animation alloc] initWithAnim:@"tom_walk.png"];
	m_tom = [[Tom alloc] initWithPos:CGPointMake(100, 100) sprite:[Sprite spriteWithAnimation:tomanim]];
	[m_tileWorld addEntity:m_tom];
    [tomanim autorelease];
}

- (void) setupEmuChick
{
    Animation *emuanim = [[Animation alloc] initWithAnim:@"emuchick.png"];
    int emucount = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 10 : 30;
	Emu **emus;
	emus = malloc(emucount * sizeof(Emu *));
	for(int i = 0; i < emucount; i++)
    {
		Emu *otheremu = [[Emu alloc] initWithPos:CGPointMake(200, 5 * TILE_SIZE) sprite:[Sprite spriteWithAnimation:emuanim]];
		[m_tileWorld addEntity:otheremu];
		emus[i] = otheremu;
	}
	m_flock = emus;
	flock_len = emucount;
    [emuanim autorelease];
}

- (void) setupBigEmu
{
    Animation *bigemu = [[Animation alloc] initWithAnim:@"emumom.png"];
	m_emuMother = [[EmuMother alloc] initWithPos:CGPointMake(7.5f * TILE_SIZE, 22.5f * TILE_SIZE) sprite:[Sprite spriteWithAnimation:bigemu]];
	[m_tileWorld addEntity:m_emuMother];
	[bigemu autorelease];
}

- (void) setupLions
{
    //intial positions of each lion. Coordinates in tile units, relative to bottom-left.
	int bottom = 3;
	int left = 1;
    int lioncount = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 14 : 29;
	int lion_positions[] = {
		1,8,
		3,10,
		3,11,
		4,8,
		4,6,
		5,9,
		7,11,
		7,5,
		8,10,
		8,6,
		9,8,
        5,30,
        3,31,
        4,40,
		15,10,    // From his point until the end, the positions are specific for iPad
		15,11,
		16,8,
		16,6,
		17,9,
		19,11,
		19,5,
		20,10,
		20,6,
		21,8,
        17,30,
        15,31,
        16,40,
        15,39,
        17,40,
        
	};
	bool lion_faceleft[] = {
		false,
		true,
		true,
		false,
		true,
		false,
		true,
		false,
		false,
		true,
		false,
        true,
        false,
        true,
		true,    // From his point until the end, the positions are specific for iPad
		true,
		false,
		true,
		false,
		true,
		false,
		false,
		true,
		false,
        true,
        false,
        true,
        false,
        true,
	};
	
    if (lioncount > 0)
    {
        Animation *lionanim = [[Animation alloc] initWithAnim:@"lion.png"];
        Animation *lionessAnim = [[Animation alloc] initWithAnim:@"lioness.png"];
        Lion **lions;
        lions = malloc(lioncount * sizeof(Lion *));
        for (int i = 0; i < lioncount; i++)
        {
            Lion *otherlion = [[Lion alloc]
                               initWithPos:CGPointMake((left+lion_positions[i * 2 + 0]) * TILE_SIZE, (bottom+lion_positions[i * 2 + 1]) * TILE_SIZE)
                               sprite:[Sprite spriteWithAnimation:random() % 100 < 25 ? lionanim :lionessAnim]
                               facingLeft:lion_faceleft[i]];
            [m_tileWorld addEntity:otherlion];
            [otherlion obstruct];
            lions[i] = otherlion;
        }
        [lionessAnim autorelease];
        [lionanim autorelease];
        m_lions = lions;
        lions_length = lioncount;
    }
}

- (void) setupGoals
{
	int bottom = 3;
	int left = 1;
    Animation *goalanim = [[Animation alloc] initWithAnim:@"star.png"];
    goals_count = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4 : 8;
    Entity **goals;
    goals = malloc(goals_count * sizeof(Entity *));
    for (int i = 0; i < goals_count; i++)
    {
        Entity *otherGoal;
        switch (i)
        {
            case 0:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 5) * TILE_SIZE, (bottom + 10) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 1:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 2) * TILE_SIZE, (bottom + 6) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 2:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 4) * TILE_SIZE, (bottom + 30) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 3:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 4) * TILE_SIZE, (bottom + 39) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 4:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 19) * TILE_SIZE, (bottom + 8) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 5:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 18) * TILE_SIZE, (bottom + 10) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 6:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 16) * TILE_SIZE, (bottom + 30) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            case 7:
                otherGoal = [[Entity alloc] initWithPos:CGPointMake((left + 16) * TILE_SIZE, (bottom + 39) * TILE_SIZE) sprite:[Sprite spriteWithAnimation:goalanim]];
                break;
            default:
                break;
        }
        [m_tileWorld addEntity:otherGoal];
        goals[i] = otherGoal;
    }
    [goalanim autorelease];
    m_goals = goals;
}

- (void) setupLogs
{
    int log_position[] = {
		4,30,
		3,32,
		5,38,
		3,40,
		8,40,
		7,41,
        18,30,    // From his point until the end, the positions are specific for iPad
        20,32,
        18,38,
        19,40,
	};
    
    Animation *loganim = [[Animation alloc] initWithAnim:@"log.png"];
    logLen = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 6 : 10;
    Rideable **logs;
	logs = malloc(logLen * sizeof(Rideable *));
	for (int i = 0; i < logLen; i++)
    {
        Rideable *otherlog = [[Rideable alloc] initWithPos:CGPointMake(log_position[i * 2 + 0] * TILE_SIZE, log_position[i * 2 +  1] * TILE_SIZE) sprite:[Sprite spriteWithAnimation:loganim]];
        otherlog.sprite.sequence = @"idle";
		[m_tileWorld addEntity:otherlog];
		logs[i] = otherlog;
	}
    m_logs = logs;
    
	[loganim autorelease];
}

- (void) setupCrocodiles
{
    int croc_position[] = {
		8,30,
		5,37,
		9,40,
        20,31, // From his point until the end, the positions are specific for iPad
        21,38,
        18,39,
	};
	
	Animation *crocanim = [[Animation alloc] initWithAnim:@"croc.png"];
    crocLen = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3 : 6;
    Crocodile **crocs;
	crocs = malloc(crocLen * sizeof(Crocodile *));
	for (int i = 0; i < crocLen; i++)
    {
        Crocodile *otherCroc = [[Crocodile alloc] initWithPos:CGPointMake(croc_position[i * 2 + 0] * TILE_SIZE, croc_position[i * 2 + 1] * TILE_SIZE + 11) sprite:[Sprite spriteWithAnimation:crocanim]];
		[m_tileWorld addEntity:otherCroc];
		crocs[i] = otherCroc;
	}
	m_crocodiles = crocs;
	[crocanim autorelease];
}

- (void) setupBushes
{
    int bush_position[] = {
		20,16,
		20,112,
		20,272,
		20,304,
		20,336,
		20,784,
		48,592,
		304,592,
		304,912,
		320,752,
		368,48,
		368,272,
		368,304,
        200,1100,
        230,1100,
        230,1330,
        20,1390,
        35,1390,
        50,1390,
        65,1390,
        220,1390,
        235,1390,
        550,20,  // From his point until the end, the positions are specific for iPad
        700,30,
        725,400,
        680,360,
        700,1000,
        600,1100,
        700,1300,
        700,900,
        720,700
	};
    
	int bush_count = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 22 : 31;
	
	Animation *bushanim = [[Animation alloc] initWithAnim:@"plant.png"];
	for(int i = 0;i < bush_count ; i++)
    {
		Entity *bush = [[Entity alloc] initWithPos:CGPointMake(bush_position[i * 2 + 0],bush_position[i * 2 + 1]) sprite:[Sprite spriteWithAnimation:bushanim]];
		[m_tileWorld addEntity:[bush autorelease]];
	}
	[bushanim release];
}

- (void) updateChicks:(float)time
{
    for (int i = 0;i < flock_len; i++)
    {
		[m_flock[i] flockAgainst:m_flock count:flock_len];
	}
    
	areChicksWithTheirMum = true;
    
	for (int i = 0; i < flock_len; i++)
    {
		[m_flock[i] avoid:m_tom];
		[m_flock[i] goal:m_emuMother];
		[m_flock[i] update:time]; //finalize movement and update sprite appearance
        
		if(distsquared(m_emuMother.position, m_flock[i].position) > 128 * 128)
        {
			areChicksWithTheirMum = false;
		}
	}
}

- (void) updateLions:(float)time
{
    for (int i = 0; i < lions_length; i++)
    {
		if([m_lions[i] wakeAgainst:m_tom])
        {
			[self onFail];
			[m_tom dieWithAnimation:@"mauled"];
		}
		[m_lions[i] update:time];
	}
}

- (void) updateGoals:(float)time
{
    for (int i = 0; i < goals_count; i++)
    {
        if (m_goals[i] && distsquared(m_tom.position, m_goals[i].position) < 32 * 32)
        {
            [m_tileWorld removeEntity:m_goals[i]];
            [[ResourceManager sharedInstance] playSound:@"tap.caf"];
            [m_goals[i] release];
            m_goals[i] = nil;
        }
    }
}

- (void) updateLogs:(float)time
{
    for (int i = 0; i < logLen; i++)
    {
		[m_logs[i] update:time];
	}
}

- (void) updateCrocodiles:(float)time
{
    for (int i = 0; i < crocLen; i++)
    {
		[m_crocodiles[i] update:time];
		if(m_tom.inJump && [m_crocodiles[i] under:m_tom.position])
        {
			[m_crocodiles[i] attack:m_tom];
			[m_tom dieWithAnimation:@"drowning"];
			[super onFail];
		}
	}
}

- (BOOL) haveAllGoalsReached
{
    BOOL allGoalsGot = YES;
    for (int i = 0; i < goals_count; i++)
    {
        if (m_goals[i] != nil)
        {
            allGoalsGot = NO;
        }
    }
    
    return allGoalsGot;
}

- (void) checkEndGame
{
    BOOL areAllGoalsReached = [self haveAllGoalsReached];
    if (areChicksWithTheirMum && endgame_state == 0 && areAllGoalsReached)
    {
        m_tom.celebrating = true;
		[self onWin:0];
		for(int i = 0; i < flock_len; i++)
        {
			m_flock[i].runawaymode = true;
		}
    }
}

- (void) checkTomSunk
{
    if (m_tom.riding && [m_tom.riding.sprite.sequence isEqualToString:@"sunk"])
    {
		[m_tom dieWithAnimation:@"drowning"];
		[super onFail];
	}
}

- (void) deallocFlock
{
    for (int i = 0; i < flock_len; i++)
    {
		[m_flock[i] release];
	}
	free(m_flock);
}

- (void) deallocLogs
{
    for (int i = 0; i < logLen; i++)
    {
		[m_logs[i] release];
	}
    free(m_logs);
}

- (void) deallocCrocodiles
{
    for (int i = 0; i < crocLen; i++)
    {
		[m_crocodiles[i] release];
	}
    free(m_crocodiles);
}

- (void) deallocGoals
{
    for (int i = 0; i < goals_count; i++)
    {
        [m_goals[i] release];
    }
    free(m_goals);
}

- (void) deallocLions
{
    for (int i = 0; i < lions_length; i++)
    {
        [m_lions[i] release];
    }
    free(m_lions);
}

@end
