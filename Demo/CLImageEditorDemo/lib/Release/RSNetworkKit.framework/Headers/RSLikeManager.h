// RSLikeManager.h
// Copyright (c) 2016 Rushi Sangani
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "Enums.h"
@import UIKit;

static NSString *kErrorCancelled   =  @"cancelled";

@interface RSLikeManager : NSObject

#pragma mark- Public Methods

/* singleton method */

+(RSLikeManager *)sharedManager;

/* set Base url for application */

-(void)initWithBaseURL:(NSString *)urlString;

/* Request configuration */

-(void)configureRequestURL:(NSString *)url requestType:(RequestType)type withHeader:(NSDictionary *)headers andParams:(NSDictionary *)params forControlState:(UIControlState)controlState;

/* Like Request */

-(void)likeRequestWithcompletion:(void (^)(id response, NSError *error))completionBlock;

/* dislike Request */

-(void)dislikeRequestWithcompletion:(void (^)(id response, NSError *error))completionBlock;

/* Cancel Like request */

-(void)cancelLikeRequest;

/* Cancel Unlike request */

-(void)cancelDislikeRequest;

@end
