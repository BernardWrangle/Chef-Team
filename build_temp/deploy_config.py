# -*- coding: utf-8 -*-
# Deployment settings for ChefTeam.
# This file is autogenerated by the mkb system and used by the s3e deployment
# tool during the build process.

config = {}
cmdline = ['C:/Marmalade/7.1/s3e/makefile_builder/mkb.py', 'c:/ChefTeam/ChefTeam.mkb', '--deploy-only']
mkb = 'c:/ChefTeam/ChefTeam.mkb'
mkf = ['c:\\marmalade\\7.1\\quick\\quick.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\openquick\\proj.marmalade\\openquick.mkf', 'c:\\marmalade\\7.1\\modules\\iwgl\\iwgl.mkf', 'c:\\marmalade\\7.1\\modules\\iwutil\\iwutil.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\libjpeg\\libjpeg.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\libpng\\libpng.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\zlib\\zlib.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\cocos2dx\\proj.marmalade\\cocos2dx.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\cocos2dx\\platform\\third_party\\marmalade\\libxml2.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\cocos2dx\\platform\\third_party\\marmalade\\freetype.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\cocos2dx\\platform\\third_party\\marmalade\\libtiff\\libtiff.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\cocosdenshion\\proj.marmalade\\cocosdenshion.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\external\\box2d\\proj.marmalade\\box2d.mkf', 'c:\\marmalade\\7.1\\modules\\third_party\\cocos2dx\\scripting\\lua\\proj.marmalade\\lua.mkf', 'c:\\marmalade\\7.1\\quick\\quickuser.mkf', 'c:\\marmalade\\7.1\\extensions\\s3efacebook\\s3efacebook.mkf', 'c:\\marmalade\\7.1\\extensions\\s3ewebview\\s3ewebview.mkf', 'c:\\marmalade\\7.1\\modules\\iwbilling\\iwbilling.mkf', 'c:\\marmalade\\7.1\\extensions\\s3eandroidmarketbilling\\s3eandroidmarketbilling.mkf', 'c:\\marmalade\\7.1\\extensions\\s3ebbappworldbilling\\s3ebbappworldbilling.mkf', 'c:\\marmalade\\7.1\\extensions\\s3eiosappstorebilling\\s3eiosappstorebilling.mkf', 'c:\\marmalade\\7.1\\extensions\\s3ewindowsphonestorebilling\\s3ewindowsphonestorebilling.mkf', 'c:\\marmalade\\7.1\\extensions\\s3eflurry\\s3eflurry.mkf']

class DeployConfig(object):
    pass

######### ASSET GROUPS #############

assets = {}

assets['Default'] = [
    ('c:/marmalade/7.1/extensions/s3efacebook/source/iphone/facebook-ios-sdk/FacebookSDK.framework/Versions/A/Resources/FacebookSDKResources.bundle/FBDialog/images/fbicon.png', 'FacebookSDKResources.bundle/FBDialog/images/fbicon.png', 0),
    ('c:/marmalade/7.1/extensions/s3efacebook/source/iphone/facebook-ios-sdk/FacebookSDK.framework/Versions/A/Resources/FacebookSDKResources.bundle/FBDialog/images/close.png', 'FacebookSDKResources.bundle/FBDialog/images/close.png', 0),
    ('c:/marmalade/7.1/extensions/s3efacebook/source/iphone/facebook-ios-sdk/FacebookSDK.framework/Versions/A/Resources/FacebookSDKResources.bundle/FBDialog/images/close@2x.png', 'FacebookSDKResources.bundle/FBDialog/images/close@2x.png', 0),
    ('c:/marmalade/7.1/extensions/s3ewebview/s3eWebView.js', 's3eWebView.js', 0),
    ('c:/ChefTeam/resources', '.', 0),
    ('c:/ChefTeam/resources/audio', 'audio', 0),
    ('c:/ChefTeam/resources/fonts', 'fonts', 0),
    ('c:/ChefTeam/resources/textures', 'textures', 0),
    ('c:/ChefTeam/resources/recipes', 'recipes', 0),
    ('c:/ChefTeam/resources/levels', 'levels', 0),
]

######### DEFAULT CONFIG #############

class DefaultConfig(DeployConfig):
    embed_icf = -1
    name = 'ChefTeam'
    pub_sign_key = 0
    priv_sign_key = 0
    caption = 'ChefTeam'
    long_caption = 'ChefTeam'
    version = [0, 0, 1]
    config = ['c:/ChefTeam/resources/common.icf', 'c:/ChefTeam/resources/app.icf']
    data_dir = 'c:/ChefTeam/resources'
    iphone_link_lib = ['s3eFacebook', 's3eWebView', 's3eIOSAppStoreBilling', 'FlurryAnalytics', 's3eFlurry']
    wp8_ext_managed_dll = ['c:/marmalade/7.1/extensions/s3efacebook/lib/wp8/s3eFacebookManaged.dll', 'c:/marmalade/7.1/extensions/s3efacebook/facebook_wp8_lib/Facebook.Client.dll', 'c:/marmalade/7.1/extensions/s3efacebook/facebook_wp8_lib/Facebook.dll', 'c:/marmalade/7.1/extensions/s3ewebview/lib/wp8/s3eWebViewManaged.dll', 'c:/marmalade/7.1/extensions/s3eflurry/lib/wp8/FlurryWP8SDK.dll', 'c:/marmalade/7.1/extensions/s3eflurry/lib/wp8/s3eFlurryManaged.dll']
    linux_ext_lib = []
    android_extra_application_manifest = ['c:/marmalade/7.1/extensions/s3eandroidmarketbilling/s3eAndroidMarketBillingManifest.xml']
    iphone_link_libdir = ['c:/marmalade/7.1/extensions/s3efacebook/lib/iphone', 'c:/marmalade/7.1/extensions/s3ewebview/lib/iphone', 'c:/marmalade/7.1/extensions/s3eiosappstorebilling/lib/iphone', 'c:/marmalade/7.1/extensions/s3eflurry/lib/iphone']
    iphone_link_libdirs = []
    iphone_link_opts = ['-F$MARMALADE_ROOT/extensions/s3eFacebook/source/iphone/facebook-ios-sdk -framework FacebookSDK -weak_framework AdSupport -weak_framework Accounts -weak_framework Social -lsqlite3']
    android_external_jars = ['c:/marmalade/7.1/extensions/s3efacebook/lib/android/s3eFacebook.jar', 'c:/marmalade/7.1/extensions/s3ewebview/lib/android/s3eWebView.jar', 'c:/marmalade/7.1/extensions/s3eandroidmarketbilling/lib/android/s3eAndroidMarketBilling.jar', 'c:/marmalade/7.1/extensions/s3eflurry/lib/android/s3eFlurry.jar', 'c:/marmalade/7.1/extensions/s3eflurry/lib/android/FlurryAgent.jar']
    android_external_res = []
    android_supports_gl_texture = []
    android_extra_manifest = []
    wp8_ext_native_dll = ['c:/marmalade/7.1/extensions/s3efacebook/lib/wp8/s3eFacebookExtension.dll', 'c:/marmalade/7.1/extensions/s3ewebview/lib/wp8/s3eWebViewExtension.dll', 'c:/marmalade/7.1/extensions/s3eflurry/lib/wp8/s3eFlurryExtension.dll']
    win32_ext_dll = ['c:/marmalade/7.1/extensions/s3ewebview/lib/win32/s3eWebView.dll', 'c:/marmalade/7.1/extensions/s3eflurry/lib/win32/s3eFlurry.dll']
    android_so = ['c:/marmalade/7.1/extensions/s3efacebook/lib/android/libs3eFacebook.so', 'c:/marmalade/7.1/extensions/s3ewebview/lib/android/libs3eWebView.so', 'c:/marmalade/7.1/extensions/s3eandroidmarketbilling/lib/android/libs3eAndroidMarketBilling.so', 'c:/marmalade/7.1/extensions/s3eflurry/lib/android/libs3eFlurry.so']
    osx_ext_dll = ['c:/marmalade/7.1/extensions/s3ewebview/lib/osx/libs3eWebView.dylib']
    tizen_so = []
    wp8_ext_capabilities = []
    iphone_link_libs = []
    target = {
         'gcc_x86' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_x86/ChefTeam.so',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_x86/ChefTeam.so',
                 },
         'gcc_x86_tizen' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_x86_tizen/ChefTeam.s86',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_x86_tizen/ChefTeam.s86',
                 },
         'mips_gcc' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_mips/ChefTeam.so',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_mips/ChefTeam.so',
                 },
         'arm_gcc' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_arm/ChefTeam.s3e',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_arm/ChefTeam.s3e',
                 },
         'mips' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_mips/ChefTeam.so',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_mips/ChefTeam.so',
                 },
         'gcc_x86_android' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_gcc_x86_android/ChefTeam.so',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_gcc_x86_android/ChefTeam.so',
                 },
         'arm' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_arm/ChefTeam.s3e',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_arm/ChefTeam.s3e',
                 },
         'x86' : {
                   'debug'   : r'c:/ChefTeam/build_temp/Debug_ChefTeam_VC10_x86/ChefTeam.s86',
                   'release' : r'c:/ChefTeam/build_temp/Release_ChefTeam_VC10_x86/ChefTeam.s86',
                 },
        }
    assets = assets['Default']

default = DefaultConfig()

######### Configuration: Windows

c = DeployConfig()
config['Windows'] = c
c.os = ['win32']
c.arch = ['x86']
c.target_folder = 'Windows'

######### Configuration: Mac OS X

c = DeployConfig()
config['Mac OS X'] = c
c.os = ['osx']
c.arch = ['x86']
c.target_folder = 'Mac OS X'
