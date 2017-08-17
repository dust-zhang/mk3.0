//
//  ServiceFeedback.h
//  movikr
//
//  Created by Mapollo27 on 3/11/16.
//  Copyright © 2016 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceFeedback : NSObject

+ (void)upLoadFeedbackContent:(NSInteger)feedbackType feedbackContent:(NSString *) feedbackContent email:(NSString *)email imageList:(NSArray *)arryImage
                        model:(void (^)(RequestResult *model))success  failure:(void (^)(NSError *error))failure;
@end
