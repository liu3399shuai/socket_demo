//
//  ChatTool.m
//  ChatDemo
//
//  Created by yang on 7/1/13.
//  Copyright (c) 2013 yang. All rights reserved.
//

#import "ChatTool.h"
#import "QFChatPotocol.h"


NSString * toString(struct QFChatResponseProtocol *res) {
    return [NSString stringWithFormat:@"%d %d %s", res->status, res->payloadLength, res->msg];
}


@implementation ChatTool
- (id) init {
    self = [super init];
    if (self) {
        _serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    return self;
}
- (void) connectToServer:(NSString *)host {
    int port = 1234;
    NSError *error = nil;
    [_serverSocket connectToHost:host
                onPort:port
                error:&error];
}

- (void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"已经连接上 %@:%d", host, port);
}

- (void) registerWithName:(NSString *)name
             withPassword:(NSString *)password
             withNickName:(NSString *)nickName
                  withQmd:(NSString *)qmd {
    struct QFRegisterRequest regInfo;
    regInfo.header.type = QF_Register;
    regInfo.header.subType = 0;
    regInfo.header.reserverd = 0;
    regInfo.header.payloadLength = sizeof(struct QFUserInfo);
    regInfo.user.userID = 0;
    strcpy(regInfo.user.username, [name UTF8String]);
    strcpy(regInfo.user.password, [password UTF8String]);
    strcpy(regInfo.user.nickname, [nickName UTF8String]);
    strcpy(regInfo.user.qmd, [qmd UTF8String]);
    NSData *d = [[NSData alloc] initWithBytes:&regInfo length:sizeof(struct QFRegisterRequest)];
    [_serverSocket writeData:d withTimeout:60 tag:TAG_WRITE_REGISTER];
    [d release];
}

char * getMyIp(void) {
    return "192.168.1.139";
}
- (void) loginWithName:(NSString *)name
          withPassword:(NSString *)password {
    struct QFLoginRequest loginRes;
    
    strcpy(loginRes.username, [name UTF8String]);
    strcpy(loginRes.password, [password UTF8String]);
    strcpy(loginRes.lanIP, getMyIp());
    loginRes.lanPort = 3456;
    loginRes.gpsLatitude = 45.566;
    loginRes.gpsLongitude = 116.222;
    loginRes.header.type = QF_Login;
    loginRes.header.subType = 0;
    loginRes.header.reserverd = 0;
    loginRes.header.payloadLength = sizeof(struct QFLoginRequest);
    
    NSData *d = [[NSData alloc] initWithBytes:&loginRes length:sizeof(struct QFLoginRequest)];
    [_serverSocket writeData:d withTimeout:60 tag:TAG_WRITE_LOGIN];
    [d release];

}

- (void) getProfile:(int)userId {
    struct  QFProfileRequest res;
    res.userID = userId;
    res.header.type = QF_Profile;
    res.header.subType = 0;
    res.header.reserverd = 0;
    res.header.payloadLength = sizeof(struct QFProfileRequest);
    NSData *d = [[NSData alloc] initWithBytes:&res length:sizeof(struct QFProfileRequest)];
    [_serverSocket writeData:d withTimeout:60 tag:TAG_WRITE_PROFILE];
    [d release];
}

- (void) getAllProfile {
    struct QFGetAllProfilesRequest res;
    res.header.type = QF_GetAllProfiles;
    res.header.subType = 0;
    res.header.reserverd = 0;
    res.header.payloadLength = sizeof(struct QFGetAllProfilesRequest);
    NSData *d = [[NSData alloc] initWithBytes:&res length:sizeof(struct QFGetAllProfilesRequest)];
    [_serverSocket writeData:d withTimeout:60 tag:TAG_WRITE_ALLPROFILE];
    [d release];

}

- (void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if (tag == TAG_WRITE_REGISTER) {
        // 注册发送完成
        int len = sizeof(struct  QFRegisterResponse);
        [_serverSocket readDataToLength:len withTimeout:60 tag:TAG_READ_REGISTER];
        // 读取服务器给我发的 读取长度 len
        // 数据还没有来
    } else if (tag == TAG_WRITE_LOGIN) {
        // 证明发送完成
        // 读取
        int len = sizeof(struct QFLoginResponse);
        [_serverSocket readDataToLength:len withTimeout:60 tag:TAG_READ_LOGIN];
    } else if (tag == TAG_WRITE_PROFILE) {
        int len = sizeof(struct QFProfileResponse);
        [_serverSocket readDataToLength:len withTimeout:60 tag:TAG_READ_PROFILE];
    } else if (tag == TAG_WRITE_ALLPROFILE) {
        int len = sizeof(struct QFGetAllProfilesResponse);
        [_serverSocket readDataToLength:len withTimeout:60 tag:TAG_READ_ALLPROFILE];
    }
}

- (void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    const void *cData = [data bytes];
    if (tag == TAG_READ_REGISTER) {
        // 数据真的来了
        struct QFRegisterResponse  *rresponse = (struct QFRegisterResponse *)cData;
        NSLog(@"register response is %@", toString(&(rresponse->response)));
        // 基于状态机的一个编程state machine.
        // 33+434*42+4323/44*44343
    } else if (tag == TAG_READ_LOGIN) {
        struct  QFLoginResponse  *rresponse = (struct QFLoginResponse *)cData;
        if (rresponse->response.status == 0) {
            NSLog(@"success login id %d", rresponse->userID);
        }
    } else if (tag == TAG_READ_PROFILE) {
        struct  QFProfileResponse  *rresponse = (struct QFProfileResponse *)cData;
        if (rresponse->response.status == 0) {
            NSLog(@"ip is %s", rresponse->duserInfo.lanIP);
            NSLog(@"gps is %f", rresponse->duserInfo.gpsLatitude);

        }
    } else if (tag == TAG_READ_ALLPROFILE) {
        struct  QFGetAllProfilesResponse  *rresponse = (struct QFGetAllProfilesResponse *)cData;
        if (rresponse->response.status == 0) {
            num = rresponse->profilesNum;
            NSLog(@"num is %d", num);
            int dataLen =num*sizeof(struct QFProfiles);
            
            [_serverSocket readDataToLength:dataLen withTimeout:60 tag:TAG_READ_ALLPROFILE2];
        }

    } else if (tag == TAG_READ_ALLPROFILE2) {
        // 读取所有的用户信息
        struct QFProfiles *allProfiles = (struct QFProfiles *)cData;
        for (int i = 0; i < num; i++) {
            struct QFProfiles *oneProfile = &allProfiles[i];
        }
    }
}

@end
