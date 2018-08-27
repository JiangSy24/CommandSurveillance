# IM-Code
# CommandSurveillance
IM代码 路径：CommandSurveillance/Classes/IMTool 这个里面的设计是值得大家学习的，后期会封成一个framework，提供外部服务。
# 下面是要导入的库 use_frameworks!
workspace 'CommandSurveillance’

xcodeproj 'CommandSurveillance.xcodeproj'


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
