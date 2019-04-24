source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'BookMe' do

	pod 'Alamofire', '~> 4.0'
	pod 'SDWebImage'
	pod 'RealmSwift', '~> 3'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'RxSwift'
    	pod 'RxCocoa'
	pod 'AMScrollingNavbar', '~> 3.0'
	pod 'CSStickyHeaderFlowLayout'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end