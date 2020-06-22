/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6_PLUS_NAMESTRING        @"iPhone 6 Plus"
#define IPHONE_6S_NAMESTRING            @"iPhone 6S"
#define IPHONE_6S_PLUS_NAMESTRING       @"iPhone 6S Plus"
#define IPHONE_SE_NAMESTRING            @"iPhone SE"
#define IPHONE_7_PLUS_NAMESTRING        @"iPhone 7 Plus"
#define IPHONE_7_NAMESTRING             @"iPhone 7"
#define IPHONE_8_NAMESTRING             @"iPhone 8"
#define IPHONE_8_PLUS_NAMESTRING        @"iPhone 8 Plus"
#define IPHONE_X_NAMESTRING             @"iPhone X"
#define IPHONE_XS_NAMESTRING            @"iPhone XS"
#define IPHONE_XSMAX_NAMESTRING         @"iPhone XS Max"
#define IPHONE_XR_NAMESTRING            @"iPhone XR"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"

#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_AIR_NAMESTRING             @"iPad Air"
#define IPAD_AIR2_NAMESTRING            @"iPad Air 2"
#define IPAD_MINI_NAMESTRING            @"iPad Mini"
#define IPAD_PRO_9_7_INCH_NAMESTRING    @"iPad Pro 9.7-inch"
#define IPAD_PRO_12_9_INCH_1G_NAMESTRING   @"iPad Pro 12.9-inch 1G"
#define IPAD_PRO_12_9_INCH_2G_NAMESTRING   @"iPad Pro 12.9-inch 2G"
#define IPAD_PRO_10_5_NAMESTRING        @"iPad Pro 10.5-inch"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_5G_NAMESTRING           @"Apple TV 5G"

#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDeviceIPhone1G,
    UIDeviceIPhone3G,
    UIDeviceIPhone3GS,
    UIDeviceIPhone4,
    UIDeviceIPhone4S,
    UIDeviceIPhone5,
    UIDeviceIPhone5S,
    UIDeviceIPhone6,
    UIDeviceIPhone6Plus,
    UIDeviceIPhone6S,
    UIDeviceIPhone6SPlus,
    UIDeviceIPhoneSE,
    UIDeviceIPhone7,
    UIDeviceIPhone7Plus,
    UIDeviceIPhone8,
    UIDeviceIPhone8Plus,
    UIDeviceIPhoneX,
    UIDeviceIPhoneXS,
    UIDeviceiPhoneXSMax,
    UIDeviceIPhoneXR,
    
    UIDeviceIPod1G,
    UIDeviceIPod2G,
    UIDeviceIPod3G,
    UIDeviceIPod4G,
    UIDeviceIPod5G,
    UIDeviceIPod6G,
    
    UIDeviceIPad1G,
    UIDeviceIPad2G,
    UIDeviceIPad3G,
    UIDeviceIPad4G,
    UIDeviceIPad5G,
    UIDeviceIPad6G,

    UIDeviceIPadAir,
    UIDeviceIPadAir2,
    UIDeviceIPadMini1G,
    UIDeviceIPadMini2G,
    UIDeviceIPadMini3G,
    
    UIDeviceIPadPro9_7in,
    UIDeviceIPadPro12_9in_1G,
    UIDeviceIPadPro12_9in_2G,

    UIDeviceIPadPro10_5in,

    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    UIDeviceAppleTV5,

    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,
	
} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

@interface UIDevice (APAdditions)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) cpuCount;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

- (BOOL) hasRetinaDisplay;
- (UIDeviceFamily) deviceFamily;
+ (BOOL)isJailBroken;
@end
