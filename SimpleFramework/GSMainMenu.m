//
//  GSMainMenu.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "GSMainMenu.h"
#import "GameStateManager.h"
#import "EmuLevel.h"
#import "ResourceManager.h"

@implementation GSMainMenu
 
- (GSMainMenu *)initWithFrame:(CGRect)frame andManager:(GameStateManager *)gameStateMgr
{
    self = [super initWithFrame:frame andManager:gameStateMgr];
	if (self)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            [[NSBundle mainBundle] loadNibNamed:@"GSMainMenu_iPad" owner:self options:nil];
        }
        else
        {
            [[NSBundle mainBundle] loadNibNamed:@"GSMainMenu_iPhone" owner:self options:nil];
        }
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default"]];
        subview.backgroundColor = background;
		[self addSubview:subview];
	}
    
    [[ResourceManager sharedInstance] stopMusic];
	[[ResourceManager sharedInstance] playMusic:@"island.mp3"];
    
	return self;
}

- (IBAction) goEmuLevel;
{
    [[ResourceManager sharedInstance] stopMusic];
	[gameStateManager changeState:[EmuLevel class]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
