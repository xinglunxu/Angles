//
//  Ball.m
//  Angles
//
//  Created by xinglunxu on 11/28/14.
//  Copyright (c) 2014 xinglunxu. All rights reserved.
//

#import "Ball.h"

@implementation Ball

-(void)ChangeSpeed_:(float) s{speed_=s;}
-(void) setOB{OutBound=false;}
-(float) getOB{return OutBound;}
-(float) getPX{return PositionX;}
-(float) getPY{return PositionY;}
-(float) getVX{return VectorX;}
-(float) getVY{return VectorY;}
//-(float) getS{return speed;}

-(id)initWithImage:(UIImageView *)ball
{
    self = [super init];
    if(self)
    {
        OutBound = false;
        speed_= 0.35;
        PositionX = 1; PositionY = 1;
        VectorX = 0; VectorY = 4;
        speed = sqrt(pow(VectorX,2) + pow(VectorY,2));
        PBall = ball;
        PBall.center = CGPointMake(PositionX, PositionY);
        LastHit[0] = 0;LastHit[1] = 0;LastHit[2] = 0;
    }
    return self;
}


-(void) Move
{
    PositionX += VectorX*speed_; PositionY += VectorY*speed_;
    PBall.center = CGPointMake(PositionX, PositionY);
}

-(BOOL) CheckCollide:(float) x1 secondvalue:(float) y1 thirdvalue:(float) x2 finalvalue:(float) y2
{
    float A = y1 - y2, B = x2 - x1, C = x1*y2 - x2*y1;
    if(LastHit[0]==A && LastHit[1]==B && LastHit[2]==C){return false;}
    float d = fabs(A*PositionX + B*PositionY + C)/sqrt(pow(A,2) + pow(B,2));
//    NSLog(@"Speed: %f,  distance: %f   ",speed, d);
    return speed > d;
}


-(void) Collide:(float) x1 secondvalue:(float) y1 thirdvalue:(float) x2 finalvalue:(float) y2
{
    float A = y1 - y2, B = x2 - x1, C = 0;
    float OldVectorX = VectorX, OldVectorY = VectorY;
    VectorX = ((pow(B,2)-pow(A,2))*OldVectorX-2*A*B*OldVectorY-2*A*C)/(pow(A,2) + pow(B,2));
    VectorY = ((pow(A,2)-pow(B,2))*OldVectorY-2*A*B*OldVectorX-2*B*C)/(pow(A,2) + pow(B,2));
    C = x1*y2 - x2*y1;
    LastHit[0]=A;LastHit[1]=B;LastHit[2]=C;
//    NSLog(@"New:%f, %f Old:%f, %f", VectorX, VectorY, OldVectorX, OldVectorY);
//    NSLog(@"A:%f, B:%f  C:%f", A, B, C);
}

-(void)ToCenter:(float) x secondvalue:(float) y
{
    float vector_x = x - PositionX;
    float vector_y = y - PositionY;
    float factor = sqrt(pow(speed, 2)/(pow(vector_x, 2)+pow(vector_y, 2)));
    VectorX = vector_x * factor;
    VectorY = vector_y * factor;
    speed_= 0.35;
    OutBound = true;
}


@end