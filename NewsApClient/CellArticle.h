//
//  CellArticle.h
//  NewsApClient
//
//  Created by ialexk on 07.12.2018.
//  Copyright © 2018 @ialexk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellArticle : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *text;
@end

NS_ASSUME_NONNULL_END
