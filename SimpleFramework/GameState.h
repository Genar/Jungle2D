//
//  GameState.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStateManager.h"

@interface GameState : UIView
{
    GameStateManager *gameStateManager;
}
- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager*)gameStateMgr;
- (void) render;
- (void) update;

@end
