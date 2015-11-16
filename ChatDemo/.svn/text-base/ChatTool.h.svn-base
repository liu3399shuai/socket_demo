//
//  ChatTool.h
//  ChatDemo
//
//  Created by yang on 7/1/13.
//  Copyright (c) 2013 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#define TAG_WRITE_REGISTER 100
#define TAG_WRITE_LOGIN 101
#define TAG_WRITE_PROFILE 102
#define TAG_WRITE_ALLPROFILE 103
#define TAG_WRITE_ALLPROFILE2 104


#define TAG_READ_REGISTER 500
#define TAG_READ_LOGIN 501
#define TAG_READ_PROFILE 502
#define TAG_READ_ALLPROFILE 503
#define TAG_READ_ALLPROFILE2 504

@interface ChatTool : NSObject
    <AsyncSocketDelegate>
{
    AsyncSocket *_serverSocket;
    
    int num;
}

- (void) connectToServer:(NSString *)host;

- (void) registerWithName:(NSString *)name
             withPassword:(NSString *)password
             withNickName:(NSString *)nickName
            withQmd:(NSString *)qmd;

- (void) loginWithName:(NSString *)name
          withPassword:(NSString *)password;

- (void) getProfile:(int)userId;
- (void) getAllProfile;
@end
