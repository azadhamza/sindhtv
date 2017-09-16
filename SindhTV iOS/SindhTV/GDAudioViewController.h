//
//  GDAudioViewController.h
//  SindhTV
//
//  Created by intellisense on 27/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface GDAudioViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{

    AVAudioRecorder *audioRecorder;
   
    
    int timeSec ;
    int timeMin  ;
    NSTimer *timer;
}
//@property (nonatomic, retain) POVoiceHUD *voiceHud;
@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;




//@property (strong, nonatomic) IBOutlet UIButton *startbtn;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;


@property BOOL stoped;

- (IBAction)startRec:(id)sender;
- (IBAction)sendToServer:(id)sender;
- (IBAction)stop:(id)sender;



///////////////////////////
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

- (IBAction)cancelVw:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *popUpView;
- (IBAction)playAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *playBtn;



@end
