//
//  SplashView.m
//  Albase
//
//  Created by Mac on 04/02/15.
//  Copyright (c) 2015 sbrtech. All rights reserved.
//

#import "SplashView.h"
#import "OCRViewController.h"

@implementation SplashView

-(void)viewDidLoad
{
    UIImageView *BagImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [BagImageView setBackgroundColor:[UIColor clearColor]];
    [BagImageView setImage:[UIImage imageNamed:@"launch.png"]];
    [self.view addSubview:BagImageView];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(GoToDifferentView) userInfo:nil repeats:NO];
}
-(void)GoToDifferentView
{
    OCRViewController *MianViewController = [[OCRViewController alloc] initWithNibName:@"OCRViewController" bundle:nil];
    [self GotoDifferentViewWithAnimation:MianViewController];
}
-(void)GotoDifferentViewWithAnimation:(UIViewController *)ViewControllerName {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:ViewControllerName animated:NO];
    
}
@end
