platform :ios, '10.0'
use_frameworks!

target 'TrueDate' do
 
    pod 'SwiftyJSON'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'RealmSwift'
    pod 'Alamofire'
    pod 'AlamofireImage', '~> 3.3'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Bond', '~> 6.3'
    pod 'XLPagerTabStrip'
    
    pod 'ObjectMapper'
    pod 'SDWebImage'
    pod 'Pulsator'
    pod 'Koloda', :git => 'https://github.com/Yalantis/Koloda.git', :branch => 'swift-3'
    pod 'JSQMessagesViewController', :git => 'https://github.com/jessesquires/JSQMessagesViewController.git', :branch => 'develop'
    
    pod 'ImageSlideshow', '~> 1.5'
    pod "ImageSlideshow/Alamofire"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

