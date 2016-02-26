//
//  PointMath.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PI_MATH_VALUE 3.14159265f

typedef struct PolarCoord
{
	float theta;
	float magnitude;
} PolarCoord;

CGPoint add (CGPoint a, CGPoint b);
CGPoint sub (CGPoint a, CGPoint b);
CGPoint scale(CGPoint a, float mag);
CGPoint clamp(CGPoint a, float magsquared);
CGFloat distsquared(CGPoint a, CGPoint b);
CGPoint toward(CGPoint a, CGPoint b);
CGPoint unit(CGPoint a);
PolarCoord PolarCoordFromPoint(CGPoint a);
CGPoint PointFromPolarCoord(PolarCoord p);
float thetaToward(float a, float b, float step);

CG_INLINE PolarCoord PolarCoordMake(CGFloat theta, CGFloat magnitude)
{
    PolarCoord p; p.theta = theta; p.magnitude = magnitude; return p;
}

float min(float a, float b);
float sign(float a);

//clockwise from straight up, in opengl coords.
int cheapsin[4];
int cheapcos[4];
