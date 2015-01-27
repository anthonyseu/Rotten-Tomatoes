//
//  MovieDetailViewController.h
//  Rotten Tomatoes
//
//  Created by Li Jiao on 1/25/15.
//  Copyright (c) 2015 Li Jiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) NSDictionary *movieObj;
@property (weak, nonatomic) UIImage *thumbImage;
@end
