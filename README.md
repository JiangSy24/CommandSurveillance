# IM-Code
# CommandSurveillance
///下面是要导入的库
workspace 'CommandSurveillance’

xcodeproj 'CommandSurveillance.xcodeproj'

# use_frameworks!
target :CommandSurveillance do
platform :ios, ‘8.0’
pod "MBProgressHUD"
pod "MJRefresh"
pod "Reachability"
pod "Masonry"
#pod "IQKeyboardManager"跟UISearchController 位置分享那冲突
pod "RSKImageCropper"
pod "KRVideoPlayer"
pod "SDWebImage"
pod "FDStackView"
pod "BaiduMapKit" #百度地图SDK
pod "YYCache"
pod "BGFMDB"
pod "AgoraAudio_iOS"
pod "AFNetworking"
pod "MJExtension"

#高德地图相关SDK（无IDFA版）
pod "AMapLocation-NO-IDFA"
pod "AMapSearch-NO-IDFA"
pod "AMap2DMap-NO-IDFA"

xcodeproj 'CommandSurveillance.xcodeproj'
end
