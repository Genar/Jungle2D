//
//  GSMainMenu.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"

@interface GSMainMenu : GameState
{
    IBOutlet UIView *subview;
}

- (IBAction) goEmuLevel;

@end
