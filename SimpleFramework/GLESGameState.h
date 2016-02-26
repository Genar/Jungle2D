//
//  GLESGameState.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"

#define WINNING 1
#define LOSING 2

@interface GLESGameState : GameState
{
        int endgame_state;
    @private
        float endgame_complete_time;
}

- (id) initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager;
+ (void) setup2D;
- (void) startDraw;
- (void) swapBuffers;
- (BOOL) bindLayer;
- (void) onWin:(int)level;
- (void) onFail;
- (void) renderEndgame;
- (void) updateEndgame:(float)time;
- (void) touchEndgame;
//helper method used to convert a touch's screen coordinates to opengl coordinates.
- (CGPoint) touchPosition:(UITouch *)touch;

@end
