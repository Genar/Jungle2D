//
//  AppDelegate.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStateManager.h"

@class ViewController;

#define ProgressionSavefile @"progression"

@interface AppDelegate : GameStateManager <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

- (int) getFramesPerSecond;

@end
