//
//  ViewController.h
//  Angles
//
//  Created by xinglunxu on 11/27/14.
//  Copyright (c) 2014 xinglunxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ball.h"

int BOTTOM = 0;
int LEFT = 1;
int TOP = 2;
int RIGHT = 3;

UIBezierPath *path;
CAShapeLayer *shapeLayer;
NSTimer *testTimer;

BOOL GameOver;
float n1,n2;
int bound;
float touchBeginX;
float touchBeginY;
float touchMoveX;
float touchMoveY;
Ball *AbstractBall;
float ScreenWidth;
float ScreenHeight;
float difficulties;
int combos;
BOOL LineReady;

float test = 0;

@interface ViewController : UIViewController
{
    IBOutlet UIButton *start;
    IBOutlet UIImageView *ImageBall;
    IBOutlet UIImageView *BottomBar;
    IBOutlet UIImageView *UpperBar;
    IBOutlet UIImageView *LeftBar;
    IBOutlet UIImageView *RightBar;
    IBOutlet UITextField *combo;
}

-(IBAction)StartGame:(id)sender;
-(void)DisplayPath: (float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)BallMove;
-(CGPoint)getInters:(CGPoint)start second: (CGPoint)end;
-(BOOL)checkInside:(CGPoint) point;
-(BOOL)OnTarget:(int) direction second:(float) n1 third:(float) n2;
-(void)ChangeTarget;

@end

