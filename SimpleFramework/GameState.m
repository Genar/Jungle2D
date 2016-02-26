//
//  GameState.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "GameState.h"

@implementation GameState

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager *)gameStateMgr;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        gameStateManager = gameStateMgr;
    }
    
    return self;
}

- (void) update
{
	
}

- (void) render
{
	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
    // Drawing code
//}

@end
