//
//  MovieTableViewCell.h
//  Rotten Tomatoes
//
//  Created by Li Jiao on 1/25/15.
//  Copyright (c) 2015 Li Jiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailPoster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieYear;
@property (weak, nonatomic) IBOutlet UILabel *movieRuntime;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;
@end
