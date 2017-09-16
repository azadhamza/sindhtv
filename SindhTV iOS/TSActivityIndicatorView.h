//
//  TSActivityIndicatorView
//  TSActivityIndicatorView-Demo
//
//  Created by Tomasz Szulc on 14.08.2013.
//  Copyright (c) 2013 Tomasz Szulc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSActivityIndicatorView : UIView

/**
 Fill this property with names of images if you want to configure view programically
 @[NSString, NSSTring, NSSTring, ..., NSString];
 */
@property NSArray *frames;

/**
 Use this property if you want to configure frames by IB.
 This string should looks like this: activity-indicator-1, activity-indicator-2, ..., activity-indicator-n
 */
@property NSString *framesAsString;

@property CGFloat duration; /// default 1.0f
@property BOOL hidesWhenStopped; /// Default YES
@property NSInteger repeatCount; /// Default -1

@property (readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

/**
 Call this method if you want to create view programically. If you want to make view from IB then initWithCoder: will be called automatically.
 */
- (id)initWithFrame:(CGRect)frame;

@end
