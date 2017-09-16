//
//  GDArticlesWebView.h
//  SindhTV
//
//  Created by intellisense on 23/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDArticlesWebView : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *ArticlesWebVw;
@property(strong,nonatomic)NSString *urlString,*epaperUrl,*fromEpaper,*about,*contactusUrl;

@property BOOL isfromPrograms;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForWebVw;
@end
