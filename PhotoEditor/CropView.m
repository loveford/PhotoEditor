//
//  CropView.m
//  PhotoEditor
//
//  Created by mouwenbin on 5/11/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "CropView.h"

@interface CropView ()
{
    IBOutlet UIImageView* arrow1;
    IBOutlet UIImageView* arrow2;
    IBOutlet UIImageView* arrow3;
    IBOutlet UIImageView* arrow4;
    
    IBOutlet UIView *lineLeft;
    IBOutlet UIView *lineRight;
    IBOutlet UIView *lineTop;
    IBOutlet UIView *lineBottom;
    IBOutlet UIView *cropView;
}
@end

@implementation CropView
{
    CGPoint panGestureStartPoint;
}
@synthesize startInset;
@synthesize delegate = _delegate;
@synthesize superView;

- (void)dealloc
{
    self.superView = nil;
    self.delegate = nil;
    [super dealloc];
}
-(void)awakeFromNib
{
    self.startInset = UIEdgeInsetsMake(15, 15, 15, 15); // default inset
    [self configureInitialLinesAndCorners];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event

{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == cropView || hitView == self)
        
    {
        
        return nil;
        
    }
    
    else
        
    {
        
        return hitView;
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) configureInitialLinesAndCorners{
    int half = lineTop.frame.size.height/2; // half of line view
    
    lineTop.frame= CGRectMake(startInset.left, startInset.top-half, self.frame.size.width-startInset.left-startInset.right,lineTop.frame.size.height);
    
    lineBottom.frame= CGRectMake(startInset.left, self.frame.size.height-startInset.bottom-half, self.frame.size.width-startInset.left-startInset.right,lineBottom.frame.size.height);
    
    lineLeft.frame = CGRectMake(startInset.left-half, startInset.top, lineLeft.frame.size.width, self.frame.size.height-startInset.top-startInset.bottom);
    lineRight.frame = CGRectMake(self.frame.size.width-startInset.right - half, startInset.top, lineRight.frame.size.width, self.frame.size.height-startInset.top-startInset.bottom);
    [self configureLinesAndCorners];
}
-(void) configureLinesAndCorners{
    lineTop.frame= CGRectMake(lineLeft.center.x, lineTop.frame.origin.y, lineRight.center.x-lineLeft.center.x,lineTop.frame.size.height);
    lineBottom.frame= CGRectMake(lineLeft.center.x, lineBottom.frame.origin.y, lineRight.center.x-lineLeft.center.x,lineBottom.frame.size.height);
    lineLeft.frame = CGRectMake(lineLeft.frame.origin.x, lineTop.center.y, lineLeft.frame.size.width, lineBottom.center.y-lineTop.center.y);
    lineRight.frame = CGRectMake(lineRight.frame.origin.x, lineTop.center.y, lineRight.frame.size.width, lineBottom.center.y-lineTop.center.y);
    [arrow1 setCenter:CGPointMake(lineLeft.center.x, lineTop.center.y)];
    [arrow2 setCenter:CGPointMake(lineRight.center.x, lineTop.center.y)];
    [arrow3 setCenter:CGPointMake(lineLeft.center.x, lineBottom.center.y)];
    [arrow4 setCenter:CGPointMake(lineRight.center.x, lineBottom.center.y)];
    [cropView setFrame:CGRectMake(arrow1.center.x, arrow1.center.y, lineTop.frame.size.width, lineRight.frame.size.height)];
}
-(void) moveLine:(UIView*)line withPoint:(CGPoint)point{
    CGPoint finalPoint;
    
    if (line==lineLeft || line==lineRight){
        point = CGPointMake(point.x, line.frame.origin.y);
        finalPoint = CGPointMake(point.x+panGestureStartPoint.x,point.y);
    }else{
        point = CGPointMake(line.frame.origin.x,point.y);
        finalPoint = CGPointMake(point.x,point.y+panGestureStartPoint.y);
    }
    CGRect frame = line.frame;
    CGFloat halfWidth = lineLeft.frame.size.width/2;
    
    if (line==lineTop){
        CGFloat y =  MAX(-halfWidth,MIN(lineBottom.center.y-halfWidth*3,finalPoint.y));
        frame.origin.y = y;
    } else if (line==lineBottom){
        frame.origin.y = MIN(self.frame.size.height-halfWidth, MAX(finalPoint.y,lineTop.center.y+halfWidth));
    } else if (line==lineLeft){
        frame.origin.x = MAX(-halfWidth,MIN(lineRight.center.x-halfWidth*3,finalPoint.x));
    } else if (line==lineRight){
        frame.origin.x = MIN(self.frame.size.width-halfWidth,MAX(finalPoint.x,lineLeft.center.x+halfWidth));
    }
    line.frame = frame;
    
}
-(IBAction) lineMoved:(UIPanGestureRecognizer*)pan{
    
    if (pan.state==UIGestureRecognizerStateBegan){
        panGestureStartPoint = pan.view.frame.origin;
    }
    [self moveLine:pan.view withPoint:[pan translationInView:self]];
    [self configureLinesAndCorners];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveVisibleRectToViewCenter];
        }];
    }
}
-(IBAction) cornerViewMoved:(UIPanGestureRecognizer*)pan{
    if (pan.state==UIGestureRecognizerStateBegan){
        panGestureStartPoint = pan.view.frame.origin;
    }
    if (pan.view==arrow1){
        [self moveLine:lineLeft withPoint:[pan translationInView:self]];
        [self moveLine:lineTop withPoint:[pan translationInView:self]];
    }else if (pan.view==arrow2){
        [self moveLine:lineTop withPoint:[pan translationInView:self]];
        [self moveLine:lineRight withPoint:[pan translationInView:self]];
    } else if (pan.view==arrow3){
        [self moveLine:lineLeft withPoint:[pan translationInView:self]];
        [self moveLine:lineBottom withPoint:[pan translationInView:self]];
    } else if (pan.view==arrow4){
        [self moveLine:lineBottom withPoint:[pan translationInView:self]];
        [self moveLine:lineRight withPoint:[pan translationInView:self]];
    }
    [self configureLinesAndCorners];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveVisibleRectToViewCenter];
        }];
    }
}

- (CGRect) visibleRect
{
    CGRect visibleRect;
    visibleRect.origin = CGPointMake(lineLeft.center.x, lineTop.center.y);
    visibleRect.size = CGSizeMake(lineRight.center.x-lineLeft.center.x, lineBottom.center.y-lineTop.center.y);
    return visibleRect;
}

- (void)moveVisibleRectToViewCenter
{
    return;
    float xOffset = superView.view.center.x - cropView.center.x;
    float yOffset = superView.view.center.y - cropView.center.y;
    cropView.center = superView.view.center;
    [arrow1 setCenter:CGPointMake(arrow1.center.x + xOffset, arrow1.center.y + yOffset)];
    [arrow2 setCenter:CGPointMake(arrow2.center.x + xOffset, arrow2.center.y + yOffset)];
    [arrow3 setCenter:CGPointMake(arrow3.center.x + xOffset, arrow3.center.y + yOffset)];
    [arrow4 setCenter:CGPointMake(arrow4.center.x + xOffset, arrow4.center.y + yOffset)];
    
    [lineTop setCenter:CGPointMake(lineTop.center.x + xOffset, lineTop.center.y + yOffset)];
    [lineLeft setCenter:CGPointMake(lineLeft.center.x + xOffset, lineLeft.center.y + yOffset)];
    [lineRight setCenter:CGPointMake(lineRight.center.x + xOffset, lineRight.center.y + yOffset)];
    [lineBottom setCenter:CGPointMake(lineBottom.center.x + xOffset, lineBottom.center.y + yOffset)];

}


@end
