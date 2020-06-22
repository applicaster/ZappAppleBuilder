/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <ZappPlugins/UIDevice+APAdditions.h>
#import "UIDevice+APAdditions.h"

@implementation UIDevice (APAdditions)
/*
 Platforms
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/GSM, N89
 iPhone3,2 ->    iPhone 4/GSM Rev A, N90
 iPhone3,3 ->    iPhone 4/CDMA, N92
 iPhone4,1 ->    iPhone 4S/GSM+CDMA, N94
 iPhone5,1 ->    iPhone 5/GSM, N41
 iPhone5,2 ->    iPhone 5/GSM+CDMA, N42
 iPhone5,3 ->    iPhone 5C/GSM, N48
 iPhone5,4 ->    iPhone 5C/GSM+CDMA, N49
 iPhone6,1 ->    iPhone 5S/GSM, N51
 iPhone6,2 ->    iPhone 5S/GSM+CDMA, N53
 iPhone7,1 ->    iPhone 6 Plus
 iPhone7,2 ->    iPhone 6
 iPhone8,1 ->    iPhone 6s
 iPhone8,2 ->    iPhone 6s Plus
 
 iPod1,1   ->    iPod touch 1, N45
 iPod2,1   ->    iPod touch 2, N72
 iPod2,2   ->    iPod touch 3, Prototype
 iPod3,1   ->    iPod touch 3, N18
 iPod4,1   ->    iPod touch 4, N81
 
 // Thanks NSForge
 ipad0,1   ->    iPad, Prototype
 iPad1,1   ->    iPad 1, WiFi and 3G, K48
 iPad2,1   ->    iPad 2, WiFi, K93
 iPad2,2   ->    iPad 2, GSM 3G, K94
 iPad2,3   ->    iPad 2, CDMA 3G, K95
 iPad2,4   ->    iPad 2, WiFi R2, K93A
 iPad3,1   ->    The new iPad, WiFi
 iPad3,2   ->    The new iPad, CDMA
 iPad3,3   ->    The new iPad
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??
 
 i386, x86_64 -> iPhone Simulator
 */


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
	
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
	
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceIPhone1G;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceIPhone3G;
    if ([platform hasPrefix:@"iPhone2"])            return UIDeviceIPhone3GS;
    if ([platform hasPrefix:@"iPhone3"])            return UIDeviceIPhone4;
    if ([platform hasPrefix:@"iPhone4"])            return UIDeviceIPhone4S;
    if ([platform hasPrefix:@"iPhone5"])            return UIDeviceIPhone5;
    if ([platform hasPrefix:@"iPhone6"])            return UIDeviceIPhone5S;

    if ([platform isEqualToString:@"iPhone7,2"])    return UIDeviceIPhone6;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDeviceIPhone6Plus;
    if ([platform isEqualToString:@"iPhone8,1"])    return UIDeviceIPhone6S;
    if ([platform isEqualToString:@"iPhone8,2"])    return UIDeviceIPhone6SPlus;
    if ([platform isEqualToString:@"iPhone8,4"])    return UIDeviceIPhoneSE;
    if ([platform isEqualToString:@"iPhone9,1"])    return UIDeviceIPhone7;
    if ([platform isEqualToString:@"iPhone9,2"])    return UIDeviceIPhone7Plus;
    if ([platform isEqualToString:@"iPhone9,3"])    return UIDeviceIPhone7;
    if ([platform isEqualToString:@"iPhone9,4"])    return UIDeviceIPhone7Plus;
    if ([platform isEqualToString:@"iPhone10,1"])   return UIDeviceIPhone8;
    if ([platform isEqualToString:@"iPhone10,4"])   return UIDeviceIPhone8;
    if ([platform isEqualToString:@"iPhone10,2"])   return UIDeviceIPhone8Plus;
    if ([platform isEqualToString:@"iPhone10,5"])   return UIDeviceIPhone8Plus;
    if ([platform isEqualToString:@"iPhone10,3"])   return UIDeviceIPhoneX;
    if ([platform isEqualToString:@"iPhone10,6"])   return UIDeviceIPhoneX;
    if ([platform isEqualToString:@"iPhone11,2"])   return UIDeviceIPhoneXS;
    if ([platform isEqualToString:@"iPhone11,6"])   return UIDeviceiPhoneXSMax;
    if ([platform isEqualToString:@"iPhone11,4"])   return UIDeviceiPhoneXSMax;
    if ([platform isEqualToString:@"iPhone11,8"])   return UIDeviceIPhoneXR;

    if ([platform hasPrefix:@"iPhone7"])            return UIDeviceIPhone6;
    if ([platform hasPrefix:@"iPhone8"])            return UIDeviceIPhone6S;

    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDeviceIPod1G;
    if ([platform hasPrefix:@"iPod2"])              return UIDeviceIPod2G;
    if ([platform hasPrefix:@"iPod3"])              return UIDeviceIPod3G;
    if ([platform hasPrefix:@"iPod4"])              return UIDeviceIPod4G;
    if ([platform hasPrefix:@"iPod5"])              return UIDeviceIPod5G;
    if ([platform hasPrefix:@"iPod7"])              return UIDeviceIPod6G;

    // iPad
    if ([platform isEqualToString:@"iPad4,1"])      return UIDeviceIPadAir;
    if ([platform isEqualToString:@"iPad4,2"])      return UIDeviceIPadAir;
    if ([platform isEqualToString:@"iPad5,3"])      return UIDeviceIPadAir2;
    if ([platform isEqualToString:@"iPad5,4"])      return UIDeviceIPadAir2;

    if ([platform isEqualToString:@"iPad2,5"])      return UIDeviceIPadMini1G;
    if ([platform isEqualToString:@"iPad2,6"])      return UIDeviceIPadMini1G;
    if ([platform isEqualToString:@"iPad2,7"])      return UIDeviceIPadMini1G;

    if ([platform isEqualToString:@"iPad4,4"])      return UIDeviceIPadMini2G;
    if ([platform isEqualToString:@"iPad4,5"])      return UIDeviceIPadMini2G;
    if ([platform isEqualToString:@"iPad4,6"])      return UIDeviceIPadMini2G;

    if ([platform isEqualToString:@"iPad4,7"])      return UIDeviceIPadMini3G;
    if ([platform isEqualToString:@"iPad4,8"])      return UIDeviceIPadMini3G;
    if ([platform isEqualToString:@"iPad4,9"])      return UIDeviceIPadMini3G;

    if ([platform isEqualToString:@"iPad6,3"])      return UIDeviceIPadPro9_7in;
    if ([platform isEqualToString:@"iPad6,4"])      return UIDeviceIPadPro9_7in;
    if ([platform isEqualToString:@"iPad6,7"])      return UIDeviceIPadPro12_9in_1G;
    if ([platform isEqualToString:@"iPad6,8"])      return UIDeviceIPadPro12_9in_1G;
    if ([platform isEqualToString:@"iPad7,1"])      return UIDeviceIPadPro12_9in_2G;
    if ([platform isEqualToString:@"iPad7,2"])      return UIDeviceIPadPro12_9in_2G;
    if ([platform isEqualToString:@"iPad7,3"])      return UIDeviceIPadPro10_5in;
    if ([platform isEqualToString:@"iPad7,4"])      return UIDeviceIPadPro10_5in;

    if ([platform hasPrefix:@"iPad1"])              return UIDeviceIPad1G;
    if ([platform hasPrefix:@"iPad2"])              return UIDeviceIPad2G;
    if ([platform hasPrefix:@"iPad3"])              return UIDeviceIPad3G;
    if ([platform hasPrefix:@"iPad4"])              return UIDeviceIPad4G;
    if ([platform hasPrefix:@"iPad5"])              return UIDeviceIPad5G;
    if ([platform hasPrefix:@"iPad6"])              return UIDeviceIPad6G;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    if ([platform hasPrefix:@"AppleTV5"])           return UIDeviceAppleTV5;


    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
	
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDeviceIPhone1G: return IPHONE_1G_NAMESTRING;
        case UIDeviceIPhone3G: return IPHONE_3G_NAMESTRING;
        case UIDeviceIPhone3GS: return IPHONE_3GS_NAMESTRING;
        case UIDeviceIPhone4: return IPHONE_4_NAMESTRING;
        case UIDeviceIPhone4S: return IPHONE_4S_NAMESTRING;
        case UIDeviceIPhone5: return IPHONE_5_NAMESTRING;
        case UIDeviceIPhone6: return IPHONE_6_NAMESTRING;
        case UIDeviceIPhone6Plus: return IPHONE_6_PLUS_NAMESTRING;
        case UIDeviceIPhone6S: return IPHONE_6S_NAMESTRING;
        case UIDeviceIPhone6SPlus: return IPHONE_6S_PLUS_NAMESTRING;
        case UIDeviceIPhoneSE: return IPHONE_SE_NAMESTRING;
        case UIDeviceIPhone7: return IPHONE_7_NAMESTRING;
        case UIDeviceIPhone7Plus: return IPHONE_7_PLUS_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
        case UIDeviceIPhone8: return IPHONE_8_NAMESTRING;
        case UIDeviceIPhone8Plus: return IPHONE_8_PLUS_NAMESTRING;
        case UIDeviceIPhoneX: return IPHONE_X_NAMESTRING;
        case UIDeviceIPhoneXS: return IPHONE_XS_NAMESTRING;
        case UIDeviceiPhoneXSMax: return IPHONE_XSMAX_NAMESTRING;
        case UIDeviceIPhoneXR: return IPHONE_XR_NAMESTRING;
            
        case UIDeviceIPod1G: return IPOD_1G_NAMESTRING;
        case UIDeviceIPod2G: return IPOD_2G_NAMESTRING;
        case UIDeviceIPod3G: return IPOD_3G_NAMESTRING;
        case UIDeviceIPod4G: return IPOD_4G_NAMESTRING;
        case UIDeviceIPod5G: return IPOD_5G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDeviceIPad1G : return IPAD_1G_NAMESTRING;
        case UIDeviceIPad2G : return IPAD_2G_NAMESTRING;
        case UIDeviceIPad3G : return IPAD_3G_NAMESTRING;
        case UIDeviceIPad4G : return IPAD_4G_NAMESTRING;
        case UIDeviceIPadAir : return IPAD_AIR_NAMESTRING;
        case UIDeviceIPadAir2 : return IPAD_AIR2_NAMESTRING;
        case UIDeviceIPadMini1G : return IPAD_MINI_NAMESTRING;
        case UIDeviceIPadMini2G : return IPAD_MINI_NAMESTRING;
        case UIDeviceIPadMini3G : return IPAD_MINI_NAMESTRING;
        case UIDeviceIPadPro9_7in : return IPAD_PRO_9_7_INCH_NAMESTRING;
        case UIDeviceIPadPro12_9in_1G : return IPAD_PRO_12_9_INCH_1G_NAMESTRING;
        case UIDeviceIPadPro12_9in_2G : return IPAD_PRO_12_9_INCH_2G_NAMESTRING;
        case UIDeviceIPadPro10_5in : return IPAD_PRO_10_5_NAMESTRING;

        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceAppleTV5 : return APPLETV_5G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	
    free(buf);
    return outstring;
}

// Illicit Bluetooth check -- cannot be used in App Store
/*
 Class  btclass = NSClassFromString(@"GKBluetoothSupport");
 if ([btclass respondsToSelector:@selector(bluetoothStatus)])
 {
 printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
 bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
 printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
 }
 */

+ (BOOL)isJailBroken
{
    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    return [[UIApplication sharedApplication] canOpenURL:url];
}
@end
