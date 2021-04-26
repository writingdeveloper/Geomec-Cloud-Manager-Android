//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <file_picker/FilePickerPlugin.h>
#import <flutter_secure_storage/FlutterSecureStoragePlugin.h>
#import <open_file/OpenFilePlugin.h>
#import <package_info/PackageInfoPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <permission_handler/PermissionHandlerPlugin.h>
#import <share_extend/ShareExtendPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <ssh/SshPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
  [OpenFilePlugin registerWithRegistrar:[registry registrarForPlugin:@"OpenFilePlugin"]];
  [FLTPackageInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPackageInfoPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [FLTShareExtendPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTShareExtendPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SshPlugin registerWithRegistrar:[registry registrarForPlugin:@"SshPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end
