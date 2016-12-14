//
//  AliMapViewShopCell.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  显示商店内容的cell

#import "AliMapViewShopCell.h"
#import "AliMapViewShopCellFrame.h"
#import "AliMapViewShopModel.h"

@implementation AliMapViewShopCell

/**
 *  商店名称Label
 */
-(UILabel *)shopNameLabel{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc]init];
        _shopNameLabel.font = [UIFont systemFontOfSize:14];
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameLabel.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _shopNameLabel;
}


/**
 *  商店电话Label
 */
-(UILabel *)shopTelLabel{
    if (!_shopTelLabel) {
        _shopTelLabel = [[UILabel alloc]init];
        _shopTelLabel.font = [UIFont systemFontOfSize:13];
        _shopTelLabel.textAlignment = NSTextAlignmentLeft;
        _shopTelLabel.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _shopTelLabel;
}


/**
 *  商店类型Label
 */
-(UILabel *)shopTypeLabel{
    if (!_shopTypeLabel) {
        _shopTypeLabel = [[UILabel alloc]init];
        _shopTypeLabel.font = [UIFont systemFontOfSize:13];
        _shopTypeLabel.textAlignment = NSTextAlignmentLeft;
        _shopTypeLabel.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _shopTypeLabel;
}


/**
 *  商店地址Label
 */
-(UILabel *)shopAddressLabel{
    if (!_shopAddressLabel) {
        _shopAddressLabel = [[UILabel alloc]init];
        _shopAddressLabel.font = [UIFont systemFontOfSize:13];
        _shopAddressLabel.textAlignment = NSTextAlignmentLeft;
        _shopAddressLabel.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _shopAddressLabel;
}


/**
 *  商店评分Label
 */
-(UILabel *)shopRatingLabel{
    if (!_shopRatingLabel) {
        _shopRatingLabel = [[UILabel alloc]init];
        _shopRatingLabel.font = [UIFont systemFontOfSize:13];
        _shopRatingLabel.textAlignment = NSTextAlignmentLeft;
        _shopRatingLabel.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _shopRatingLabel;
}

/**
 *  商店图片View
 */
-(AliMapViewShopImageView *)shopImageView{
    if (!_shopImageView) {
        _shopImageView = [[AliMapViewShopImageView alloc]init];
    }
    return _shopImageView;
}


/**
 *  初始化控件
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.shopTelLabel];
        [self.contentView addSubview:self.shopTypeLabel];
        [self.contentView addSubview:self.shopRatingLabel];
        [self.contentView addSubview:self.shopAddressLabel];
        [self.contentView addSubview:self.shopImageView];
    }
    return self;
}


/**
 *  接收cellFrame
 */
-(void)setShopCellFrame:(AliMapViewShopCellFrame *)shopCellFrame{
    _shopCellFrame = shopCellFrame;
    
    //商店名称Label
    self.shopNameLabel.frame = shopCellFrame.shopNameLabelFrame;
    if (shopCellFrame.shopModel.shopName) {
        self.shopNameLabel.text = shopCellFrame.shopModel.shopName;
    }
    
    //商店电话Label
    self.shopTelLabel.frame = shopCellFrame.shopTelLabelFrame;
    if (shopCellFrame.shopModel.shopTel) {
        self.shopTelLabel.text = [NSString stringWithFormat:@"电话:%@",shopCellFrame.shopModel.shopTel];
    }

    //商店类型Label
    self.shopTypeLabel.frame = shopCellFrame.shopTypeLabelFrame;
    if (shopCellFrame.shopModel.shopType) {
        self.shopTypeLabel.text = [NSString stringWithFormat:@"类型:%@",shopCellFrame.shopModel.shopType];
    }
    
    //商店地址Label
    self.shopAddressLabel.frame = shopCellFrame.shopAddressLabelFrame;
    if (shopCellFrame.shopModel.shopAddress) {
        self.shopAddressLabel.text = [NSString stringWithFormat:@"地址:%@",shopCellFrame.shopModel.shopAddress];
    }
    
    
    //商店评分Label
    self.shopRatingLabel.frame = shopCellFrame.shopRatingLabelFrame;
    if (shopCellFrame.shopModel.shopRating) {
        self.shopRatingLabel.text = [NSString stringWithFormat:@"评分:%@",shopCellFrame.shopModel.shopRating];
    }
    
    //商店图片View
    self.shopImageView.frame = shopCellFrame.shopImageViewFrame;
    if (shopCellFrame.shopModel.shopImages) {
        self.shopImageView.urls = shopCellFrame.shopModel.shopImages;
    }
}

//类方法创建cell
+(instancetype)createCellWithTableView:(UITableView *)tableView{
    
    static NSString *reuserIdentifier = @"Cell";
    AliMapViewShopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[AliMapViewShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    return cell;
}

@end
