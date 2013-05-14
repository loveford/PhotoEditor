//
//  CropViewCtrl.h
//  PhotoEditor
//
//  Created by mouwenbin on 5/13/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CropViewCtrlDelegate<NSObject>
-(void) cropImageViewControllerDidFinished:(UIImage*)image; // cropped image
@end
@interface CropViewCtrl : UIViewController
@property (nonatomic, assign) id<CropViewCtrlDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
-(id) initWithImage:(UIImage*)image;
@end
