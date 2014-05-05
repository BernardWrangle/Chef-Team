#
# (C) 2001-2012 Marmalade. All Rights Reserved.
#
# This document is protected by copyright, and contains information
# proprietary to Marmalade.
#
# This file consists of source code released by Marmalade under
# the terms of the accompanying End User License Agreement (EULA).
# Please do not use this program/source code before you have read the
# EULA and have agreed to be bound by its terms.
#
import deploy_config

config = deploy_config.config
cmdline = deploy_config.cmdline
mkb = deploy_config.mkb
mkf = deploy_config.mkf

assets = deploy_config.assets

class HubConfig(deploy_config.DefaultConfig):
    iphone_application_type = "universal"
    iphone_appid = r"com.Eric.ChefTeam"
    iphone_icon_7_group = {}
    iphone_icon_7_search_group = {}
    iphone_splash_group_iphone = {}
    iphone_splash_group_ipad = {}
    assets = assets["Default"]
    name = r"ChefTeam"
    caption = r"ChefTeam"
    provider = r"Eric"
    copyright = r"(C) Eric"
    version = [0, 0, 1]
    iphone_icon_group = {}
    iphone_icon_search_group = {}
    iphone_region = r"English"
    iphone_distribution_cert = r"C:/Users/Eric/Documents/iOS Cert/ios_development.cer"
    iphone_distribution_key = r"C:/Marmalade/7.1/s3e/deploy/plugins/iphone/certificates/developer_identity.key"
    iphone_development_cert = r"C:/Marmalade/7.1/s3e/deploy/plugins/iphone/certificates/ios_development.cer"
    iphone_development_key = r"C:\Marmalade\7.1\s3e/deploy/plugins/iphone/certificates/developer_identity.key"
    pass

default = HubConfig()
