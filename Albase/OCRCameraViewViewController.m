//
//  OCRCameraViewViewController.m
//  Albase
//
//  Created by Mac on 05/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRCameraViewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>
#import "RecognitionViewController.h"
#import "OCRAppDelegate.h"

@interface OCRCameraViewViewController ()
{
     BOOL isCapturingImage;
}
@property (nonatomic,retain) UIView *MainCameraBgView;
@property (strong, nonatomic) UIView * imageStreamV;
@property (strong, nonatomic) UIImageView * capturedImageV;

// AVFoundation Properties
@property (strong, nonatomic) AVCaptureSession * mySesh;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureDevice * myDevice;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;
@end

@implementation OCRCameraViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=((([[UIScreen mainScreen] bounds].size.height)>500))?[super initWithNibName:@"OCRCameraViewViewController" bundle:nil]:[super initWithNibName:@"OCRCameraViewViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[self.navigationController navigationBar] setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    
    self.MainCameraBgView = [self.view viewWithTag:456];
    [self.MainCameraBgView setBackgroundColor:[UIColor redColor]];
    [self.MainCameraBgView.layer setBorderWidth:1.0f];
    [self.MainCameraBgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:self.MainCameraBgView];
    [self addcameraView];
}
- (void) capturePhoto {
    
    if (isCapturingImage) {
        return;
    }
    isCapturingImage = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if (!error) {
             
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage * capturedImage = [[UIImage alloc]initWithData:imageData scale:1];
         
         if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
             
//             if ([[self machineName] isEqualToString:@"iPod"]) {
//                 
//                 // rear camera active
//                 if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//                     CGImageRef cgRef = capturedImage.CGImage;
//                     capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDownMirrored];
//                 }
//                 else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//                     CGImageRef cgRef = capturedImage.CGImage;
//                     capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUpMirrored];
//                 }
//                 
//             } else {
             
                 // rear camera active
                 if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                     CGImageRef cgRef = capturedImage.CGImage;
                     capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUp];
                 }
                 else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                     CGImageRef cgRef = capturedImage.CGImage;
                     capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
                 }
                 
             //}
         }
         _capturedImageV.contentMode = UIViewContentModeScaleAspectFill;
         _capturedImageV.clipsToBounds = YES;
         [_capturedImageV setImage:capturedImage];
         [(OCRAppDelegate*)[[UIApplication sharedApplication] delegate] setImageToProcess:capturedImage];
         capturedImage = nil;
         imageData = nil;
         } else {
             NSLog(@"image capture error --- %@",error);
         }
     }];
}
- (IBAction)Recognize:(id)sender
{
    [self capturePhoto];
    NSLog(@"capturePhoto ");
    RecognitionViewController *Recognition = [[RecognitionViewController alloc] init];
    [self.navigationController pushViewController:Recognition animated:YES];
}
-(void)addcameraView
{
    if (_imageStreamV == nil)
        _imageStreamV = [[UIView alloc]init];
    
    _imageStreamV.alpha = 1;
    _imageStreamV.frame = self.MainCameraBgView.bounds;
    [self.MainCameraBgView  addSubview:_imageStreamV];
    
    if (_mySesh == nil) _mySesh = [[AVCaptureSession alloc] init];
    _mySesh.sessionPreset = AVCaptureSessionPresetPhoto;
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_mySesh];
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.frame = _imageStreamV.layer.bounds;
    
    [_imageStreamV.layer addSublayer:_captureVideoPreviewLayer];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count==0) {
        NSLog(@"SC: No devices found (for example: simulator)");
        return;
    }
    _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
    if ([_myDevice isFlashAvailable] && _myDevice.flashActive && [_myDevice lockForConfiguration:nil]) {        _myDevice.flashMode = AVCaptureFlashModeOff;
        [_myDevice unlockForConfiguration];
    }
    
    NSError * error = nil;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:&error];
    if (!input) {
        NSLog(@"SC: ERROR: trying to open camera: %@", error);
    }
    [_mySesh addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_mySesh addOutput:_stillImageOutput];
    [_mySesh startRunning];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
}
- (void) viewDidAppear:(BOOL)animated {
    _imageStreamV.alpha = 1;
}
-(void)deallocCameraview
{
    [_mySesh stopRunning];
    _mySesh       = nil;
    
    [_imageStreamV removeFromSuperview];
    _imageStreamV = nil;
    
    [_captureVideoPreviewLayer removeFromSuperlayer];
    _captureVideoPreviewLayer = nil;
    
    _myDevice = nil;
    _stillImageOutput= nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self deallocCameraview];
}
@end
