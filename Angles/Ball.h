//
//  Ball.h
//  Angles
//
//  Created by xinglunxu on 11/28/14.
//  Copyright (c) 2014 xinglunxu. All rights reserved.
//

#ifndef Angles_Ball_h
#define Angles_Ball_h

#import <Foundation/Foundation.h>//
#import <UIKit/UIKit.h>

@interface Ball : NSObject
{
    float VectorX, VectorY;
    float PositionX, PositionY;
    float speed;
    IBOutlet UIImageView *PBall;
    float LastHit[3];
    float speed_;
    BOOL OutBound;
}

-(void)ChangeSpeed_:(float) s;
-(void) setOB;
-(float) getOB;
-(float) getPX;
-(float) getPY;
-(float) getVX;
-(float) getVY;
//-(float) getS;

-(void) Move;
-(BOOL) CheckCollide:(float) x1 secondvalue:(float) y1 thirdvalue:(float) x2 finalvalue:(float) y2;
-(void) Collide:(float) x1 secondvalue:(float) y1 thirdvalue:(float) x2 finalvalue:(float) y2;
-(void)ToCenter:(float) x secondvalue:(float) y;

-(id)initWithImage:(UIImageView*) ball;


@end
#endif
