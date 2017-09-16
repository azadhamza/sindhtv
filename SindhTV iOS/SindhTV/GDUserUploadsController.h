//
//  GDUserUploadsController.h
//  SindhTV
//
//  Created by intellisense on 27/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface GDUserUploadsController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIView *movieVw;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIView *voiceVw;
- (IBAction)submitBtnAction:(id)sender;
- (IBAction)voiceBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *feedBackTxtVw;
- (IBAction)videoBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property (strong, nonatomic) IBOutlet UILabel *lblForDisplay;
@property (strong, nonatomic) IBOutlet UIView *viewForTextFields;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end
