//
//   AppDevice.m
//
//   Created  by Arsenic on 2023/1/8
//   
//

#import "AppDevice.h"
#import <sys/utsname.h>

@implementation AppDevice

static NSMutableDictionary * deviceDic = nil;

static NSString * deviceName = nil;

+ (NSString * ) deviceName{
    if (deviceName) return deviceName;
    
    [self readFileIfNeed];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString * obj = [deviceDic objectForKey:code];
    if (!IsEmpty(obj)){
        deviceName = obj;
    }else{
        deviceName = @"Unknown Device";
    }
    return deviceName;
}

+ (void) readFileIfNeed{
    if (deviceDic) return;
    deviceDic = [NSMutableDictionary dictionary];
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppDevice" ofType:@"txt"] encoding:NSASCIIStringEncoding error: &error];
    NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
    for (NSString * str in lines) {
        NSArray * arr = [str componentsSeparatedByString:@"    "];
        if (arr.count == 2){
            [deviceDic setValue:arr[1] forKey:arr[0]];
        }
    }
}
    
@end
