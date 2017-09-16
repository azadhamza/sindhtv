//
//  GDAudioViewController.m
//  SindhTV
//
//  Created by intellisense on 27/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDAudioViewController.h"

@interface GDAudioViewController ()
{
    int count,clickedCount;
    NSString* timeNow;
    NSUserDefaults *defaults;
    NSString *filePath;
    AVAudioPlayer *player;
    NSData *d;
}
@end

@implementation GDAudioViewController
@synthesize audioRecorder;
@synthesize recordButton,sendButton,stopButton;
@synthesize stoped;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    defaults=[NSUserDefaults standardUserDefaults];
    
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    
    
       self.popUpView.layer.cornerRadius=4;
    self.popUpView.layer.masksToBounds=YES;
    self.popUpView.layer.borderWidth=2;
    self.popUpView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.recordButton.layer.cornerRadius=3;
    self.recordButton.layer.masksToBounds=YES;
    [self.recordButton setBackgroundColor:[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]]];
    [self.recordButton setTitleColor:[self colorWithHexString:[defaults valueForKey:@"colVwTextClr"]]  forState:UIControlStateNormal];
    
    self.sendButton.layer.cornerRadius=3;
    self.sendButton.layer.masksToBounds=YES;
    [self.sendButton setBackgroundColor:[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]]];
    [self.sendButton setTitleColor:[self colorWithHexString:[defaults valueForKey:@"colVwTextClr"]]  forState:UIControlStateNormal];
    
    self.playBtn.layer.cornerRadius=3;
    self.playBtn.layer.masksToBounds=YES;
    [self.playBtn setBackgroundColor:[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]]];
    [self.playBtn setTitleColor:[self colorWithHexString:[defaults valueForKey:@"colVwTextClr"]]  forState:UIControlStateNormal];
    self.playBtn.enabled=NO;

    count=0;
    clickedCount=0;
    sendButton.enabled = NO;
    stopButton.enabled = NO;
    stoped = YES;
    
    
    ///////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"SindhTV.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
    
    
    
    
    // Do any additional setup after loading the view.
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL) sendAudioToServer :(NSData *)data {
    d = [NSData dataWithData:data];
    
  
    //now you'll just have to send that NSData to your server
    
    return YES;
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
   filePath=[NSString stringWithFormat:@"%@", recorder.url];
    NSLog(@"stoped %@",filePath);
    
    
   // NSData *audioData=[NSData dataWithContentsOfURL:recorder.url];
    
    //if (!stoped) {
        d= [NSData dataWithContentsOfURL:recorder.url];
//        [self sendAudioToServer:data];
//        [recorder record];
//        NSLog(@"stoped sent and restarted");
    //////////////////////////////////////////////////////////////////////////
    //}
}
- (IBAction)startRec:(id)sender {
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////
    
    
    if (count==0) {
        
    if (!audioRecorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [audioRecorder record];
         [self StartTimer];
        self.playBtn.enabled=NO;
        self.sendButton.enabled=NO;
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [audioRecorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
        count=1;
    }
    
    else if(count==1)
    {
    
        [audioRecorder stop];
        
        self.playBtn.enabled=YES;
        self.sendButton.enabled=YES;
        [self StopTimer];
         [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    
        count=0;
    }
    
    
    
}

- (IBAction)sendToServer:(id)sender
{
    stoped = NO;
    [audioRecorder stop];
    
    [defaults setObject:d forKey:@"uploadData"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAudio" object:self];
}

- (IBAction)stop:(id)sender {
    
    
    stopButton.enabled = NO;
    sendButton.enabled = NO;
    recordButton.enabled = YES;
    
    stoped = YES;
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
   
}



- (void)viewDidUnload
{
    

    
   [super viewDidUnload];
    // Release any retained subviews of the main view.
}


/////////////////////////////////////////////////////////////////////////////////////////



-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

//Event called every time the NSTimer ticks.
- (void)timerTick:(NSTimer *)timer
{
    timeSec++;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    //Format the string 00:00
    timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
    //Display on your label
    //[timeLabel setStringValue:timeNow];
    self.timeLbl.text= timeNow;
}

//Call this to stop the timer event(could use as a 'Pause' or 'Reset')
- (void) StopTimer
{
    [timer invalidate];
    timeSec = 0;
    timeMin = 0;
    //Since we reset here, and timerTick won't update your label again, we need to refresh it again.
    //Format the string in 00:00
    //NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
    //Display on your label
    // [timeLabel setStringValue:timeNow];
    self.timeLbl.text= timeNow;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
        
    }
    
    if (cString.length==8) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6)
        return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (IBAction)cancelVw:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)playAction:(id)sender
{
    if (clickedCount==0)
    {
       
        NSString* resourcePath = filePath; //your url
        NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resourcePath]];
        NSError *error;
        
        player = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
        
        player.delegate=self;
//        NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
//        
//       player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
//                                                                       error:nil];
        player.numberOfLoops = 0; //Infinite
        [player prepareToPlay];
        if (player == nil)
            NSLog(@"%@", [error description]);
        else
            [player play];
        [self StartTimer];
        [self.playBtn setTitle:@"Stop" forState:UIControlStateNormal];
        self.recordButton.enabled=NO;
        self.sendButton.enabled=NO;
        clickedCount=1;
    }
    else if (clickedCount==1)
    {
        [player stop];
        [self StopTimer];
        self.recordButton.enabled=YES;
        self.sendButton.enabled=YES;
        [self.playBtn setTitle:@"Play" forState:UIControlStateNormal];
        clickedCount=0;
    }

    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    self.recordButton.enabled=YES;
    self.sendButton.enabled=YES;
    [self StopTimer];
    [self.playBtn setTitle:@"Play" forState:UIControlStateNormal];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
