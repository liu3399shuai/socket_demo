typedef unsigned int uint32t;
typedef unsigned short uint16t;
typedef unsigned short uint8t;

#define QF_Register 0x1
#define QF_Login 0x2
#define QF_ModifyUser 0x3
#define QF_ModifyDynamicUser 0x4
#define QF_Logout 0x5
#define QF_UploadHeadImage 0x6
#define QF_DownloadHeadImage 0x7
#define QF_DeleteHeadImage 0x8
#define QF_HeartBeat 0x9
#define QF_Profile 0x10
#define QF_GetAllProfiles 0x11
#define QF_SaveOfflineMsg 0x12
#define QF_ReadOfflineMsg 0x13

/**
    Socket聊天程序API接口
 */

/* 请求头的通用类型 */
struct QFChatRequestProtocol {
    uint32t  type; /* 协议类型 */
    uint32t  subType; /* 协议子类型 */
    uint32t  payloadLength; /* 协议内容长度 */
    uint32t  reserverd; /* 保留字段 */
};

/* 响应头的通用类型 */
struct QFChatResponseProtocol {
    uint32t  payloadLength; /* 协议内容长度 */
    uint32t status;
    char msg[128];
};
/** 用户静态信息: */
struct QFUserInfo {
    uint32t userID; /* 用户在服务器数据库上存放的ID */
    char  username[32];   /* 用户名; 用户名不能修改 */
    char  password[32];    /* 密码 */
    char  nickname[128]; /* 昵称 */
    char  qmd[128];            /* 用户的签名档 */
};

/** 用户动态信息: */
#define QFUSER_INFO_STATUS	 (1<<1)
#define QFUSER_INFO_LAN		 (1<<2)
#define QFUSER_INFO_WAN	 (1<<3)
#define QFUSER_INFO_GPS		 (1<<4)

struct QFDynamicUserInfo {
    uint32t userID;
    uint32t type;
    /* 后续包含的内容有什么，*/
    /* 比如有 status; 有局域网地址，有广域网地址，有gps */
    
	/* 用户的状态 */
	/* 0 Online;   1 Away;   2 Hidden;  */
    uint32t status;
    
    char  lanIP[16];         /* 局域网的ip地址 */
    char  wanIP[16];       /* 外网的ip地址 */
    uint16t  lanPort;     /* 局域网的端口 */
    uint16t  wanPort;   /* 外网的端口 */
    float  gpsLatitude;
    float gpsLongitude;
};


/* 1.  注册Register */
struct QFRegisterRequest {
    struct QFChatRequestProtocol header;
    struct QFUserInfo user;  /* 里面的userID无效 */
};
/** 成功后返回status >= 0; */
struct  QFRegisterResponse {
    struct QFChatResponseProtocol response;
};
/*
status >= 0 成功返回
status < 0 错误
错误信息放在msg中
*/

/* 2. 登陆Login */
struct  QFLoginRequest {
    struct QFChatRequestProtocol header;
    char  username[32];   /* 用户名 */
    char  password[32];    /* 密码 */
    
    char  lanIP[32];   /* 局域网的ip地址 */
    uint16t  lanPort;    /* 局域网的端口 */
    float gpsLatitude;
    float gpsLongitude;
};

/* 成功后返回 */
struct  QFLoginResponse {
    struct QFChatResponseProtocol response;
    uint32t userID;
};

/** 3. 修改用户信息ModifyUser */
struct  QFModifyUserRequest {
    struct QFChatRequestProtocol header;
    struct QFUserInfo user;
};
/*
成功返回 */
struct  QFModifyUserResponse {
    struct QFChatResponseProtocol response;
    struct QFUserInfo user;
};

/** 3. 修改用户动态信息ModifyDynamicUser */
struct  QFModifyDynamicUserRequest {
    struct QFChatRequestProtocol header;
    struct QFDynamicUserInfo user;
};
/*
主要是上传用户的ip地址; gps信息; 还有隐身状态等
成功返回 */
struct  QFModifyDynamicUserResponse {
    struct QFChatResponseProtocol response;
    struct QFDynamicUserInfo user;
};

/** 4. 注销用户 Logout */
struct  QFLogoutRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;
};

/* 成功返回 */
struct  QFLogoutResponse {
    struct QFChatResponseProtocol response;
};

/** 5. 上传用户头像UploadHeadImage */
struct  QFUploadHeadRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;
    char  imageData[0]; /* 头像图片数据 */
};

/* 成功返回 */
struct  QFUploadHeadUserResponse {
    struct QFChatResponseProtocol response;
};

/** 6.  获取用户头像DownloadHeadImage */
struct  QFDownloadHeadImageRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;  /* 要获取用户的id */
};

/* 成功返回 */
struct  QFDownloadHeadImageResponse {
    struct QFChatResponseProtocol response;
    uint8t imageLength;  /* 返回头像图片的字节数 */
    char  data[0];
};

/** 6.  删除用户头像DeleteHeadImage */
struct  QFDeleteHeadImageRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;  /* 要删除用户的id */
};

/* 成功返回 */
struct  QFDeleteHeadImageResponse {
    struct QFChatResponseProtocol response;
};

/** 7. 心跳HeartBeat */
struct QFHeartBeatRequest {
    struct QFChatRequestProtocol header;
    uint32t  seq;
};

/*  心跳序列号(客户端每隔10s需要发送一个心跳信号给服务器)
 否则服务器认为当前用户掉线了
成功后返回
 */

struct  QFHeartBeatResponse {
    struct QFChatResponseProtocol response;
    uint32t seq;
};
/*  返回心跳序列号+1 */

/* 8. 获取单个用户信息Profile */
struct  QFProfileRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;
};
/* 获取用户userID的Profile
如果userID <= 0 那么获取自己当前用户的Profile

成功后返回 */
struct  QFProfileResponse {
    struct QFChatResponseProtocol response;
    
    /* 用户静态信息 */
    struct QFUserInfo userInfo;
    /* 用户动态信息 */
    struct QFDynamicUserInfo duserInfo;
};

/** 9. 获取多个用户信息Profiles
后续
*/
struct QFProfiles{
    struct QFUserInfo userInfo;
    struct QFDynamicUserInfo duserInfo;
};
struct QFGetAllProfilesRequest{
    struct QFChatRequestProtocol header;
};
struct QFGetAllProfilesResponse
{
    struct QFChatResponseProtocol response;
    uint32t profilesNum;
    uint32t profilesTotalLength;
    struct QFProfiles profilesBundle[0];
};

// 离线消息部分
#define QFMSG_TEXT   (1<<1)
#define QFMSG_IMAGE   (1<<2)
#define QFMSG_VOICE   (1<<3)
struct QFMessage {
    uint32t fromUserID;
    uint32t toUserID;
    uint32t type;  /* 单次消息类型 */
    uint32t msgLength;  /* 单词消息长度 */
    char  msgBody[0];    /* 消息体 */
};

struct QFMessageBundle {
    uint32t type;  /* 总的消息类型; 比如知道都有哪些消息 */
    uint32t msgNum;  /* 一共多少条消息消息的条数 */
    uint32t msgTotalLength; /* 消息总长度 */
    struct QFMessage msgs[0];
};

/** 10. 存放离线聊天信息SaveOfflineMsg */

struct  QFSaveMessageRequest {
    struct QFChatRequestProtocol header;
    struct QFMessageBundle msg;
};


/*
用户1发送给用户2的离线消息(比如用户2下线了)

成功后返回 */
struct  QFSaveMessageResponse {
    struct QFChatResponseProtocol response;
};


/* 11. 读取离线聊天信息ReadOfflineMsg */
struct  QFReadOfflineMessageRequest {
    struct QFChatRequestProtocol header;
    uint32t userID;
};

/* 返回 */
struct  QFReadOfflineMessageResponse {
    struct QFChatResponseProtocol response;
    struct QFMessageBundle msgBundle;
};
/* 如果没有离线消息，那么 msgBundle.msgNum = 0 */