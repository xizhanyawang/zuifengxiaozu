//
//  LocationModel.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "JSONModel.h"

@interface LocationModel : JSONModel

@property (strong , nonatomic)NSArray * coordinates;

@property (strong , nonatomic)NSString * type;

@end
