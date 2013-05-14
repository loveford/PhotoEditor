//
//  CropView.h
//  PhotoEditor
//
//  Created by mouwenbin on 5/11/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropViewCtrl.h"
@protocol CropViewDelegate <NSObject>
- (void)lineMoved;
- (float)cornerMoved;
@end;

@interface CropView : UIView
@property (nonatomic, assign) id<CropViewDelegate>delegate;
@property (nonatomic, retain) CropViewCtrl *superView;
@property (nonatomic, assign) UIEdgeInsets startInset;
-(IBAction) lineMoved:(UIPanGestureRecognizer*)pan;
-(IBAction) cornerViewMoved:(UIPanGestureRecognizer*)pan;
- (CGRect) visibleRect;
-(void) configureInitialLinesAndCorners;
@end
