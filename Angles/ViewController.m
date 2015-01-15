//
//  ViewController.m
//  Angles
//
//  Created by xinglunxu on 11/27/14.
//  Copyright (c) 2014 xinglunxu. All rights reserved.
//

#import "ViewController.h"
#import "Ball.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)UpdateCombo
{
    NSString* myNewString = [NSString stringWithFormat:@"%i", combos];
    combo.text = myNewString;
}

-(void)ini
{
    [AbstractBall ChangeSpeed_:0.35];
    LineReady = false;
    difficulties = ScreenHeight*0.5;
    [self ChangeTarget];
    GameOver = false;
    start.hidden = YES;
    [AbstractBall ToCenter:ScreenWidth/2 secondvalue:ScreenHeight/2];
    combos = 0;
    [self UpdateCombo];
}

-(IBAction)StartGame:(id)sender
{
    AbstractBall = [[Ball alloc] initWithImage:(ImageBall)];
    [self.view bringSubviewToFront:ImageBall];
    [self ini];
    testTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:(self) selector:@selector(BallMove) userInfo:nil repeats:YES];
    printf("%f , %f\n", ScreenWidth, ScreenHeight);
}

-(void)BallMove
{
    float x = [AbstractBall getPX];
    float y = [AbstractBall getPY];
    CGPoint start = CGPointMake(touchBeginX, touchBeginY);
    CGPoint end =CGPointMake(touchMoveX, touchMoveY);
    CGPoint interset = [self getInters:start second:end];
//    NSLog(@"Interset: %f  %f aaa", interset.x, interset.y);
    if(LineReady && [AbstractBall CheckCollide:touchBeginX secondvalue:touchBeginY thirdvalue:touchMoveX finalvalue:touchMoveY] && [self checkInside:interset])
    {[AbstractBall Collide:touchBeginX secondvalue:touchBeginY thirdvalue:touchMoveX finalvalue:touchMoveY];
        LineReady = false;
    }
    if(![AbstractBall getOB]&&(x<=0 || y<=0 || x>=ScreenWidth || y>=ScreenHeight))
    {
        if([self OnTarget:bound second:n1 third:n2])
        {
            combos++;
            [self UpdateCombo];
            [AbstractBall ToCenter:ScreenWidth/2 secondvalue:ScreenHeight/2];
            [self ChangeTarget];
        }
        else{GameOver=true;}
    }
    if(GameOver==false)
    {
        [AbstractBall Move];
        if([AbstractBall getOB] && x>0 && y>0 && x<ScreenWidth && y<ScreenHeight)
        {[AbstractBall setOB];}
    }
    else{[self ini];}
}

-(void)DisplayPath:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2
{
    path =[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x1, y1)];
    [path addLineToPoint:CGPointMake(x2, y2)];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    touchBeginX = touchPoint.x;
    touchBeginY = touchPoint.y;
    
    NSLog(@"%f   ", touchPoint.x);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [shapeLayer removeFromSuperlayer];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [self DisplayPath:touchBeginX y1:touchBeginY x2:touchPoint.x y2:touchPoint.y];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    touchMoveX = touchPoint.x; touchMoveY = touchPoint.y;
    [AbstractBall ChangeSpeed_:2.5];
    LineReady = true;
}

-(CGPoint)getInters:(CGPoint)start second:(CGPoint)end
{
    float x1 = start.x, y1 = start.y;
    float x2 = end.x, y2 = end.y;
    float x3 = [AbstractBall getPX], y3 = [AbstractBall getPY];
    float x4 = [AbstractBall getPX]+[AbstractBall getVX];
    float y4 = [AbstractBall getPY]+[AbstractBall getVY];
    
    float x = ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
    float y = ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));

    return CGPointMake(x, y);
}

-(BOOL)checkInside:(CGPoint)point
{
    NSLog(@"x: %f y: %f", point.x, point.y);
    BOOL check = true;
    if(touchBeginX<touchMoveX)
    {
        if(touchBeginX>point.x || point.x>touchMoveX){check=false;NSLog(@"1111");}
    }
    else
    {
        if(touchBeginX<point.x || point.x<touchMoveX){check=false;}
        NSLog(@"2222");
    }
    
    if(touchBeginY<touchMoveY)
    {
        if(touchBeginY>point.y || point.y>touchMoveY){check=false;NSLog(@"3333");}
    }
    else
    {
        if(touchBeginY<point.y || point.y<touchMoveY){check=false;}
        NSLog(@"4444");
    }
    
    
    return check;
    
}

-(BOOL)OnTarget:(int) direction second:(float) n1 third:(float) n2
{
    float x = [AbstractBall getPX];
    float y = [AbstractBall getPY];
//    printf("%f , %f\n", x, y);
//    printf("%f , %f\n", n1, n2);
//    printf("%i\n", direction);
    if(y<=0 && direction == BOTTOM)//bottom
    {
//        printf("bbbbbb");
        return x>=n1 && x<=n2;
    }
    if(x<=0 && direction == LEFT)//left
    {
        return y>=n1 && y<=n2;
    }
    if(y>=ScreenHeight && direction == TOP)//top
    {
//        printf("aaaaaaa");
        return x>=n1 && x<=n2;
    }
    if(x>=ScreenWidth && direction == RIGHT)//left
    {
        return y>=n1 && y<=n2;
    }
    return false;
    
}

-(void)ChangeTarget
{
    BottomBar.hidden = YES;
    RightBar.hidden = YES;
    LeftBar.hidden = YES;
    UpperBar.hidden = YES;
    IBOutlet UIImageView *target;
    bound = arc4random_uniform(3);
    if(bound == BOTTOM || bound == TOP)
    {
        if(bound == BOTTOM)
        {BottomBar.hidden = NO;target = BottomBar;}
        else{UpperBar.hidden = NO; target = UpperBar;}
        n1 = arc4random_uniform(ScreenWidth-difficulties);
        n2 = n1 + difficulties;
        CGPoint p = target.center;
        target.frame = CGRectMake(0, 0, difficulties, target.frame.size.height);
        target.center = CGPointMake((n1+n2)/2, p.y);
//        target.transform = CGAffineTransformMakeScale(difficulties/target.frame.size.width, 1);
    }
    
    else if(bound == LEFT || bound == RIGHT)
    {
        if(bound == LEFT)
        {LeftBar.hidden = NO; target = LeftBar;}
        else{RightBar.hidden = NO; target = RightBar;}
        n1 = arc4random_uniform(ScreenHeight-difficulties);
        n2 = n1 + difficulties;
        CGPoint p = target.center;
        target.frame = CGRectMake(0, 0, target.frame.size.width, difficulties);
        target.center = CGPointMake(p.x, (n1+n2)/2);
//        target.transform = CGAffineTransformMakeScale(1, difficulties/target.frame.size.height);
    }
    printf("n1: %f , n2: %f\n", n1, n2);
    printf("target.x: %f , target.y: %f\n", target.center.x, target.center.y);
    printf("target.width: %f , target.height: %f\n", target.frame.size.width, target.frame.size.height);
}

-(void)InPosition: (UIImageView*)  image
{
    float x,y;
    x = image.center.x; y = image.center.y;
        printf("%f , %f\n", x, y);
    image.translatesAutoresizingMaskIntoConstraints=YES;
        printf("%f , %f\n", image.center.x, image.center.y);
    image.center = CGPointMake(x, y);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    ScreenWidth =  [[UIScreen mainScreen] bounds].size.width;
    BottomBar.hidden = YES;
    RightBar.hidden = YES;
    LeftBar.hidden = YES;
    UpperBar.hidden = YES;
//
    BottomBar.center = CGPointMake(ScreenWidth/2, 0);
    UpperBar.center = CGPointMake(ScreenWidth/2, ScreenHeight);
    LeftBar.center = CGPointMake(0, ScreenHeight/2);
    RightBar.center = CGPointMake(ScreenWidth, ScreenHeight/2);
    
//    [self InPosition:BottomBar];
//    [self InPosition:RightBar];
//    [self InPosition:LeftBar];
//    [self InPosition:UpperBar];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//ＨＥＹ　AUI_2000，　Ｉ’Ｍ　ＴＲＹＩＮＧ　ＴＯ　ＬＥＡＲＮ　ＴＯ　ＰＬＡＹ　ＲＩＫＩ．　Ｉ　ＪＵＳＴ　ＨＡＶＥ　Ａ　ＱＵＥＳＴＩＯＮ　ＡＢＯＵＴ　ＴＨＥ　ＳＫＩＬＬ　ＢＵＩＬＤ：　ＳＨＯＵＬＤ　Ｉ　ＭＡＸ　ＢＡＣＫＳＴＡＢ　ＬＩＫＥ　ＹＯＵ　ＢＡＣＫＳＴＡＢＢＥＤ　C9，　ＳＭＯＫＥＳＣＲＥＥＮ　ＳＯ　ＴＨＥＹ　ＭＩＳＳ　ＭＥ　ＬＩＫＥ　ＥE　ＭＩＳＳ　ＹＯＵ　７０％　ＯＦ　ＴＨＥ　ＴＩＭＥ，　ＯＲ　ＰＥＲＭＡＮＥＴ　ＩＮＶＩＳＩＢＩＬＩＴＹ　ＳＯ　Ｉ　ＣＯＵＬＤ　ＤＩＳＡＰＰＥＡＲ　ＬＩＫＥ　ＹＯＵ　ＤＩＳＡＰＰＥＡＲＥＤ　ＦＲＯＭ　C9
