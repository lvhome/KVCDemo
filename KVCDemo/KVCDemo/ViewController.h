//
//  ViewController.h
//  KVCDemo
//
//  Created by  on 2018/11/15.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController


@end

#import <UIKit/UIKit.h>

@interface NilKVCModel : NSObject
{
    NSString * name;
}

@end

#import <UIKit/UIKit.h>

@interface SubKVCModel : NSObject
{
    NSString * title;
}

@property (nonatomic, assign)  CGFloat age;
@property (nonatomic, copy)  NSString * name;

@end

#import <UIKit/UIKit.h>

@interface KVCModel : NSObject
{
//    NSString * title;
//    NSString * isTitle;
//    NSString * _title;
//    NSString * _isTitle;
    SubKVCModel * subModel;
}
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * subTitle;
@end


