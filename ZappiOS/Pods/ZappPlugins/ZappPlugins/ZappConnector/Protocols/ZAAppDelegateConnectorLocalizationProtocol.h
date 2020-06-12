//
//  ZAAppDelegatelConnectorLocalizationProtocol.h
//  ZappAppConnector
//
//  Created by Alex Zchut on 02/07/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

@protocol ZAAppDelegateConnectorLocalizationProtocol

- (NSString *)localizationStringByKey:(NSString *)localizationKey defaultString:(NSString *)defaultString;
- (void)changeAppLocalization:(NSString *)localization;
- (NSDictionary *)remoteLocalizationDictionary;
- (NSString *)getCurrentLocalizationLanguage;
@end
