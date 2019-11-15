// UIButton+RSNetworkKit.h
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

#import "RSLikeManager.h"

@interface UIButton (RSNetworkKit)

/* Configure URL and params for button's UIControlStateNormal and UIControlStateSelected */

-(void)setURL:(NSString *)urlString requestType:(RequestType)type headers:(NSDictionary *)headers
    andParams:(NSDictionary *)params forControlState:(UIControlState)controlState;

/* like request action handler */

-(void)likeRequestWithcompletion:(void(^)(id response, NSError *error))completionBlock;

/* dislike request action handler */

-(void)dislikeRequestWithcompletion:(void(^)(id response, NSError *error))completionBlock;

@end
