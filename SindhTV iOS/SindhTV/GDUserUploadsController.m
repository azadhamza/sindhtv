//
//  GDUserUploadsController.m
//  SindhTV
//
//  Created by intellisense on 27/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDUserUploadsController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
@interface GDUserUploadsController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate>

{
    MBProgressHUD *hud;
    NSUserDefaults *defaults;
    NSDictionary *mediaInfo;
    NSString *moviePath;
    UIActivityIndicatorView *indicator;
    bool isVideo,isImage,isAudio;
    NSString *filename1;
    NSData *imageData;
    TSActivityIndicatorView *customIndicator;
    UIView *transparentVw;
    AppDelegate *appdelegate;
}

@end

@implementation GDUserUploadsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appdelegate=[[UIApplication sharedApplication] delegate];

    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    defaults=[NSUserDefaults standardUserDefaults];
    
    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    // self.navigationController.title=@"User Uploads";
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    lbl.text=@"User Uploads";
    lbl.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=lbl;
    //self.title=@"User Uploads";
    // [self.uploadBtn setTitle:@"Upload File" forState:UIControlStateNormal];
    isImage=NO;
    isVideo=NO;
    isAudio=NO;
    
    
    //view.layer.cornerRadius = 5;
    // view.layer.masksToBounds = YES;
    self.movieVw.layer.cornerRadius=4;
    self.movieVw.layer.masksToBounds=YES;
    
    self.voiceVw.layer.cornerRadius=4;
    self.voiceVw.layer.masksToBounds=YES;
    
    self.submitBtn.layer.cornerRadius=4;
    self.submitBtn.layer.masksToBounds=YES;
    
    self.feedBackTxtVw.layer.cornerRadius=4;
    self.feedBackTxtVw.layer.masksToBounds=YES;
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    self.submitBtn.backgroundColor=[UIColor colorWithRed:255/255.0 green:123/255.0 blue:0 alpha:1.0f];
    self.movieVw.backgroundColor=[UIColor colorWithRed:(124/255.0) green:(186/255.0) blue:(27/255.0) alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValue) name:@"SetAudio" object:nil];
    // Do any additional setup after loading the view.
}


-(void)setBoolValue
{
    isAudio=YES;
    isVideo=NO;
    isImage=NO;
    self.movieVw.backgroundColor=[UIColor cyanColor];
    self.lblForDisplay.text=@"Audio added";
    self.lblForDisplay.textColor=[UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)submitBtnAction:(id)sender
{
    
    //    indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //    [indicator setColor:[UIColor blueColor]];
    //    [indicator startAnimating];
    //    indicator.center=self.view.center;
    //    [self.view addSubview:indicator];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelText = @"Uploading Data...";
    
    
    
    hud.margin = 10.f;
    hud.yOffset = 30.0f;
    hud.color=[UIColor colorWithRed:11/255.0 green:160/255.0 blue:219/255.0 alpha:1.0];
    
    
    customIndicator =
    [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 40, 40)];
    customIndicator.frames = @[@"activity-indicator-1",
                               @"activity-indicator-2",
                               @"activity-indicator-3",
                               @"activity-indicator-4",
                               @"activity-indicator-5",
                               @"activity-indicator-6"];
    
    customIndicator.duration = 0.5f;
    customIndicator.hidesWhenStopped = YES;
    customIndicator.center=self.view.center;
    // [self.view addSubview:customIndicator];
    
    // [customIndicator startAnimating];
    
    
    
    [self uploadFiles];
    
}

- (IBAction)voiceBtnAction:(id)sender {
    
    // GDPOAudioViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"GDAudio"];
    //[self setModalPresentationStyle:UIModalPresentationCurrentContext];
}

- (IBAction)videoBtnAction:(id)sender
{
    self.movieVw.backgroundColor=[UIColor colorWithRed:(124/255.0) green:(186/255.0) blue:(27/255.0) alpha:1.0];
    self.lblForDisplay.text=@"Upload File";
    self.lblForDisplay.textColor=[UIColor whiteColor];
    if (IS_IPAD) {
        [self showAlertView];
    }
    else
    {
        
        [self showActionSheet];
    }
    
}

-(void)showActionSheet
{
    
    
    UIActionSheet *choosePhotoActionSheet;
    
    choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Upload Video",@"Upload Image",@"Upload Audio", nil];
    //    }
    //    else
    //    {
    //        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose photo"
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"Cancel"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"Take photo from library" ,nil];
    //    }
    // [choosePhotoActionSheet.view setTintColor:[UIColor red];
    
    choosePhotoActionSheet.tag=1000;
    
    if (IS_IPAD)
    {
        
        [choosePhotoActionSheet showFromRect:self.movieVw.frame inView:self.view animated:YES];
    }
    else
    {
        [choosePhotoActionSheet showInView:self.view];
    }
    
}


-(void)showActionSheetForVideos
{
    
    UIActionSheet *choosePhotoActionSheet1;
    
    
    choosePhotoActionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Choose"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take video from Camera",@"Take video from Library", nil];
    //    }
    //    else
    //    {
    //        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose photo"
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"Cancel"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"Take photo from library" ,nil];
    //    }
    choosePhotoActionSheet1.tag=100;
    
    if (IS_IPAD)
    {
        
        [choosePhotoActionSheet1 showFromRect:self.uploadBtn.frame inView:self.view animated:YES];
        //[choosePhotoActionSheet1 showInView:self.view];
    }
    else
    {
        [choosePhotoActionSheet1 showInView:self.view];
    }
}

-(void)showActionSheetForPhotos
{
    UIActionSheet *choosePhotoActionSheet2;
    //
    //    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //    {
    choosePhotoActionSheet2 = [[UIActionSheet alloc] initWithTitle:@"Choose"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take photo from camera",@"Take photo from library", nil];
    //    }
    //    else
    //    {
    //        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose photo"
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"Cancel"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"Take photo from library" ,nil];
    //    }
    
    
    choosePhotoActionSheet2.tag=200;
    
    if (IS_IPAD)
    {
        
        [choosePhotoActionSheet2 showFromRect:self.movieVw.frame inView:self.view animated:YES];
    }
    else
    {
        [choosePhotoActionSheet2 showInView:self.view];
    }
    
    
}
-(void)showAlertView
{
    
    UIAlertView *alrtVw=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upload Video",@"Upload Image",@"Upload Audio", nil];
    alrtVw.tag=10000;
    [alrtVw show];
    
}

-(void)showAlertViewForVideos
{
    UIAlertView *alrtVwForVideos=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take video from Camera",@"Take video from Library", nil];
    alrtVwForVideos.tag=300;
    [alrtVwForVideos show];
    
}

-(void)showAlertViewForPhotos
{
    UIAlertView *alrtVwForPhotos=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take photo from camera",@"Take photo from library", nil];
    alrtVwForPhotos.tag=400;
    [alrtVwForPhotos show];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    imagePickerController.allowsEditing = YES;
    
    
    if (actionSheet.tag==1000)
    {
        
        if (buttonIndex==0)
        {
            if (IS_IPAD)
            {
                [self showAlertViewForVideos];
                
            }
            else
                
            {
                [self showActionSheetForVideos];
            }
            
        }
        
        // imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        else if (buttonIndex==1)
        {
            //imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (IS_IPAD)
            {
                [self showAlertViewForPhotos];
                
            }
            else
                
            {
                [self showActionSheetForPhotos];
            }
            
        }
        else if (buttonIndex==2)
        {
            [self performSegueWithIdentifier:@"audioSegue" sender:self];
            
        }
        
        // [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
    if (actionSheet.tag==100)
    {
        
        if (buttonIndex==0)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
            //   [recordImageViewPicker setMediaTypes: [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            imagePickerController.mediaTypes = mediaTypes;
        }
        else if (buttonIndex==1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //[self presentViewController:imagePickerController animated:YES completion:nil];
            NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
            //   [recordImageViewPicker setMediaTypes: [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            imagePickerController.mediaTypes = mediaTypes;
            
        }
        
        
        
        
    }
    
    
    else if (actionSheet.tag==200)
    {
        
        if (buttonIndex==0) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else  if (buttonIndex==1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        // [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    imagePickerController.allowsEditing = YES;
    if (alertView.tag==10000) {
        
        if (buttonIndex==1) {
            [self   showAlertViewForVideos];
        }
        else if (buttonIndex==2) {
            [self   showAlertViewForPhotos];
        }
        else if (buttonIndex==3) {
            [self performSegueWithIdentifier:@"audioSegue" sender:self];
        }
        
        
        
        
    }
    
    if (alertView.tag==300)
    {
        if (buttonIndex==1)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //[self presentViewController:imagePickerController animated:YES completion:nil];
            NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
            //   [recordImageViewPicker setMediaTypes: [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            imagePickerController.mediaTypes = mediaTypes;
        }
        else if (buttonIndex==2)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //[self presentViewController:imagePickerController animated:YES completion:nil];
            NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
            //   [recordImageViewPicker setMediaTypes: [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            imagePickerController.mediaTypes = mediaTypes;
            
        }
        
    }
    
    if (alertView.tag==400)
    {
        if (buttonIndex==1) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else  if (buttonIndex==2)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *newVC = segue.destinationViewController;
    
    [GDUserUploadsController setPresentationStyleForSelfController:self presentingController:newVC];
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [appdelegate hideStatusBarAction];
    //forArticles
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];
    
    transparentVw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    transparentVw.backgroundColor=[UIColor clearColor];
    //transparentVw.userInteractionEnabled=NO;
    // [self.viewForTextFields addSubview:transparentVw];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelText = @"Loading....";
    
    
    
    hud.margin = 10.f;
    hud.yOffset = 30.0f;
    hud.color=[UIColor colorWithRed:11/255.0 green:160/255.0 blue:219/255.0 alpha:1.0];
    
    
    mediaInfo=info;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelectorOnMainThread:@selector(converetingData) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[hud hide:YES];
        });
    });
    //  [self converetingData];
    
}

-(void)converetingData
{
    
    
    NSString *mediaType = [mediaInfo objectForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        isImage=YES;
        isVideo=NO;
        isAudio=NO;
        
        UIImage *chosenImage = [mediaInfo objectForKey:UIImagePickerControllerEditedImage];
        
        imageData=UIImagePNGRepresentation(chosenImage);
        
        [hud removeFromSuperview];
        [hud hide:YES];
        filename1 = @"User_Image";
        self.movieVw.backgroundColor=[UIColor cyanColor];
        
        self.lblForDisplay.text=@"Image added";
        self.lblForDisplay.textColor=[UIColor blackColor];
        
        [defaults setObject:imageData forKey:@"uploadData"];
        [defaults synchronize];
        
              
        
    }
    else if ([mediaType isEqualToString:@"public.movie"])
    {
        isVideo=YES;
        isImage=NO;
        isAudio=NO;
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
        {
            
            NSURL  __block *videoUrl=(NSURL*)[mediaInfo objectForKey:UIImagePickerControllerMediaURL];
            // NSString *moviePath = [videoUrl path];
            
            //       if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            //            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            //        }
            
//            UIImage *videoImag=[self VideoThumbNail:videoUrl];
//            UIImageView*imgVw=[[UIImageView alloc]initWithFrame:CGRectMake(80, 80, 100, 100)];
//            [self.view addSubview:imgVw];
//            imgVw.image=videoImag;
            
            //upload video
            NSError *error = nil;
            AVURLAsset *videoAssetURL = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
            
            AVMutableComposition *composition = [AVMutableComposition composition];
            AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            AVAssetTrack *videoTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeVideo] firstObject];
            AVAssetTrack *audioTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeAudio] firstObject];
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
            
            CGAffineTransform transformToApply = videoTrack.preferredTransform;
            AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
            [layerInstruction setOpacity:0.0 atTime:videoAssetURL.duration];
            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAssetURL.duration);
            instruction.layerInstructions = @[layerInstruction];
            
            AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
            videoComposition.instructions = @[instruction];
            videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
            videoComposition.renderScale = 1.0;
            videoComposition.renderSize = CGSizeMake(320, 480); //select you video size 640
            
            AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
            hud.progress=0.2;
            
            
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.outputFileType = AVFileTypeMPEG4;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            basePath = [basePath stringByAppendingPathComponent:@"videos"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
                [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
            
            NSURL  *compressedVideoUrl=nil;
            compressedVideoUrl = [NSURL fileURLWithPath:basePath];
            long CurrentTime = [[NSDate date] timeIntervalSince1970];
            NSString *strImageName = [NSString stringWithFormat:@"%ld",CurrentTime];
            compressedVideoUrl=[compressedVideoUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",strImageName]];
            hud.progress=0.3;
            
            
            exportSession.outputURL = compressedVideoUrl;
            exportSession.videoComposition = videoComposition;
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration);
            
            customIndicator =
            [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 40, 40)];
            customIndicator.frames = @[@"activity-indicator-1",
                                       @"activity-indicator-2",
                                       @"activity-indicator-3",
                                       @"activity-indicator-4",
                                       @"activity-indicator-5",
                                       @"activity-indicator-6"];
            
            customIndicator.duration = 0.5f;
            customIndicator.hidesWhenStopped = YES;
            customIndicator.center=self.view.center;
            //[self.view addSubview:customIndicator];
            
            //[customIndicator startAnimating];
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                
                NSLog(@"done processing video!");
                NSLog(@"%@",compressedVideoUrl);
                
                moviePath = [videoUrl path];
               
                //hud.removeFromSuperViewOnHide = YES;
                
                
                //***
                
                if(moviePath==nil)
                {
                    
                    [[[UIAlertView alloc ]initWithTitle:nil message:@"Please choose video from your iPhone or record New video to upload" delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil]show ];
                    
                    //                    [customIndicator stopAnimating];
                    //                    [customIndicator removeFromSuperview];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud removeFromSuperview];
                            [hud hide:YES];
                            [transparentVw removeFromSuperview];
                        });
                    });
                    
                }
                else
                {
                    
                    
                    NSData *videoData= [NSData dataWithContentsOfURL:compressedVideoUrl];
                    
                    
                    [defaults setObject:videoData forKey:@"uploadData"];
                    [defaults synchronize];
                    
                    
                    
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud removeFromSuperview];
                            [hud hide:YES];
                            [transparentVw removeFromSuperview];
                            [customIndicator stopAnimating];
                            [customIndicator removeFromSuperview];
                            self.movieVw.backgroundColor=[UIColor cyanColor];
                        });
                    });
                    
                    
                    
                    self.lblForDisplay.text=@"Video added";
                    
                    
                    
                    self.lblForDisplay.textColor=[UIColor blackColor];
                    
                    
                    
                    
                    filename1 = @"User_Video";
                }
                //                    NSData *videoData= [NSData dataWithContentsOfURL:compressedVideoUrl];
                
            }];
            
        }
        
        
    }
}


//- (UIImage *)VideoThumbNail:(NSURL *)videoURL
//{
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//    UIImage *thumbnail = [player thumbnailImageAtTime:52.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//    [player stop];
//    return thumbnail;
//}
-(void)uploadFiles
{
    @try {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                       {
                           
                           
                           
                           
                           
                           NSString *urlString = [NSString stringWithFormat:@"http://poovee.net/webservices/appfeedback/2/%@?",[defaults valueForKey:@"channelID"]];
                           
                           
                           NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                           [request setURL:[NSURL URLWithString:urlString]];
                           [request setHTTPMethod:@"POST"];
                           
                           NSString *boundary = @"---------------------------14737809831466499882746641449";
                           
                           NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                           [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                           
                           NSMutableData *body = [NSMutableData data];
                           
                           //   [member_id] [img]
                           /*----------------creating boundary for memberid------------------*/
                           //                                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           //                                       NSInteger userid=[defaults integerForKey:@"UserID"];
                           //
                           [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"Content-Disposition: form-data; name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[[NSString stringWithFormat:@"%@",self.nameTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
                           // [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           
                           
                           
                           //phone number
                           
                           [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"Content-Disposition: form-data; name=\"phone\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[[NSString stringWithFormat:@"%@",self.phoneTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
                           // [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           
                           
                           
                           //////// feedback
                           
                           [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[[NSString stringWithFormat:@"%@",self.feedBackTxtVw.text] dataUsingEncoding:NSUTF8StringEncoding]];
                           // [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           
                           
                           
                           //////////////
                           
                           
                           
                           /*----------------creating boundary for photoName ------------------*/
                           [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[[NSString stringWithFormat:@"%@",self.emailTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
                           // [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                           
                           /*------creating boundary for GD Video Upload-----------------*/
                           if (isVideo)
                           {
                               
                               [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                               
                               [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.mp4\"\r\n", filename1] dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[NSData dataWithData:[defaults objectForKey:@"uploadData"]]];
                               
                               [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                               
                           }
                           //////////////////////////////////////// GD Image Upload
                           
                           
                           if (isImage)
                           {
                               
                               
                               
                               
                               
                               
                               [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                               
                               [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.png\"\r\n", filename1] dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[NSData dataWithData:[defaults objectForKey:@"uploadData"]]];
                               
                               [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           }
                           
                           
                           if (isAudio)
                           {
                               filename1=@"User_audio";
                               [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                               
                               [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio\"; filename=\"%@.m4a\"\r\n", filename1] dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                               [body appendData:[NSData dataWithData:[defaults objectForKey:@"uploadData"]]];
                               
                               [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           }
                           
                           
                           
                           ////////////////////////////////////
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              
                                              [request setHTTPBody:body];
                                              
                                              NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                              NSError *serializeError = nil;
                                              NSDictionary *jsonData = [NSJSONSerialization
                                                                        JSONObjectWithData:returnData
                                                                        options:NSJSONReadingMutableContainers
                                                                        error:&serializeError];
                                              
                                              //  NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                                              
                                              NSLog(@"print response cover image post : %@",jsonData);
                                              
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [hud removeFromSuperview];
                                                      [hud hide:YES];
                                                      
                                                  });
                                              });
                                              
                                              
                                              if ([[jsonData objectForKey:@"type"] isEqualToString:@"1"]) {
                                                  UIAlertView *alertImageSend = [[UIAlertView alloc] initWithTitle:[jsonData objectForKey:@"text"]
                                                                                                           message:[jsonData objectForKey:@"response"]
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"OK"
                                                                                                 otherButtonTitles:nil,nil];
                                                  [alertImageSend show];
                                                  
                                                  isAudio=NO;
                                                  isVideo=NO;
                                                  isImage=NO;
                                                  self.nameTextField.text=@"";
                                                  self.emailTextField.text=@"";
                                                  self.phoneTextField.text=@"";
                                                  self.feedBackTxtVw.text=@"";
                                                  self.lblForDisplay.text=@"Upload File";
                                                  self.lblForDisplay.textColor=[UIColor whiteColor];
                                                  self.movieVw.backgroundColor=[UIColor colorWithRed:(124/255.0) green:(186/255.0) blue:(27/255.0) alpha:1.0];
                                                  //                                                              self.coverPicImgageView.image=[UIImage imageWithData:imageData];
                                                  
                                              }
                                              else{
                                                  UIAlertView *alertImageSend = [[UIAlertView alloc] initWithTitle: [jsonData objectForKey:@"text"]
                                                                                                           message:nil
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"Ok"
                                                                                                 otherButtonTitles:nil,nil];
                                                  [alertImageSend show];
                                                  
                                              }
                                              
                                              //   [self getProfileData];
                                              
                                          });
                           
                       });
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"EXCEPTION IN upload Image=%@",exception);
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if (!IS_IPAD) {
//        
//        [appdelegate hideStatusBarAction];
//    }
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//                
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//    }
//    
//}
//
@end
