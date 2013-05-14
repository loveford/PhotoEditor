//
//  CropViewCtrl.m
//  PhotoEditor
//
//  Created by mouwenbin on 5/13/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "CropViewCtrl.h"
#import "CropView.h"
#import "UIImage+Extensions.h"

@interface CropViewCtrl ()
{
    
}

@property (nonatomic, retain) IBOutlet CropView *cropView;
@end

@implementation CropViewCtrl
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithImage:(UIImage *)image{
    self = [super init];
    if (self){
        [self view];
        [self setImage:image];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    CGPoint center = self.scrollView.center;
    CGFloat heightWillBe;
    CGFloat widthWillBe;
    CGSize size;
    CGFloat widthKoef = self.scrollView.frame.size.width/self.imageView.image.size.width;
    CGFloat heightKoef = self.scrollView.frame.size.height/self.imageView.image.size.height;
    if ( widthKoef < heightKoef){
        // width is bigger than height
        heightWillBe  = self.imageView.image.size.height * self.imageView.frame.size.width/self.imageView.image.size.width;
        size = CGSizeMake(self.imageView.frame.size.width, heightWillBe);
    } else {
        // height is bigger than width
        widthWillBe  = self.imageView.image.size.width * self.imageView.frame.size.height/self.imageView.image.size.height;
        size = CGSizeMake(widthWillBe, self.imageView.frame.size.height);
    }
    [self.scrollView setBounds:CGRectMake(0, 0, size.width, size.height)];
    [self.imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.scrollView setCenter:center];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.alwaysBounceVertical = NO;
    self.cropView.frame = self.scrollView.frame;
    self.cropView.startInset = UIEdgeInsetsMake(15, 15, 15, 15); // default inset
    [self.cropView configureInitialLinesAndCorners];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 0.8f;
    self.scrollView.maximumZoomScale = 5.0f;
//    self.scrollView.contentInset = UIEdgeInsetsMake(48, 32, 48, 32);
    self.cropView.superView = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.scrollView.scrollEnabled)
        return self.imageView;
    else return nil;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale {
    [aScrollView setZoomScale:scale+0.01 animated:NO];
    [aScrollView setZoomScale:scale animated:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        self.scrollView.scrollEnabled = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(allowScrollingAndZooming) object:nil];
        [self performSelector:@selector(allowScrollingAndZooming) withObject:nil afterDelay:0.2];
    }
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void) allowScrollingAndZooming{
    self.scrollView.scrollEnabled = YES;
}

-(IBAction)cancelTapped{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) saveTapped{
    if ([[self delegate] respondsToSelector:@selector(cropImageViewControllerDidFinished:)]){
        [self.delegate cropImageViewControllerDidFinished:[self cropImage]];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(UIImage*) cropImage{
    CGRect rect = [self.cropView visibleRect];
    CGFloat koef = self.imageView.image.size.width / self.scrollView.frame.size.width;
    CGRect finalImageRect = CGRectMake(rect.origin.x*koef, rect.origin.y*koef, rect.size.width*koef, rect.size.height*koef);
    UIImage *croppedImage = [self.imageView.image imageAtRect:finalImageRect];
    NSLog(@"%@",NSStringFromCGSize(self.imageView.image.size));
    return croppedImage;
}


//- (CGSize)cropImageSize
//{
//    CGRect rect = [self.cropView visibleRect];
//    CGFloat koef = self.imageView.image.size.width / self.scrollView.frame.size.width;
//    CGRect finalImageRect = CGRectMake(rect.origin.x*koef, rect.origin.y*koef, rect.size.width*koef, rect.size.height*koef);
//    return <#expression#>
//}
@end
