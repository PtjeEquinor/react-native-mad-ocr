#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

@interface RCT_EXTERN_MODULE(MadOcr, NSObject)

RCT_EXTERN_METHOD(textRecognition:(NSString) imageUri
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(tagRecognition:(NSString) imageUri
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setKnownTags:(NSArray *) tags
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}
@end
