//
//  ViewController.m
//  PhotoEditor
//
//  Created by mouwenbin on 5/11/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "ViewController.h"
#import "CropViewCtrl.h"

@interface ViewController ()<CropViewCtrlDelegate>
{
    IBOutlet UIImageView *imageView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropTapped)];
    [imageView addGestureRecognizer:tap];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cropTapped{
    CropViewCtrl *cropController = [[CropViewCtrl alloc] initWithImage:imageView.image];
    cropController.delegate = self;
    [self presentModalViewController:cropController animated:YES];
}
-(void)cropImageViewControllerDidFinished:(UIImage *)image{
    imageView.image = image;
}

@end
