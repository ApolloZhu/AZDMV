platform :ios, '10.0'
inhibit_all_warnings!
install! 'cocoapods', :generate_multiple_pod_projects => true

target 'AZDMV' do
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Firestore'

  pod 'BulletinBoard'
  pod 'CHTCollectionViewWaterfallLayout/Swift', :git => 'https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git', :branch => 'master'
  pod 'ReverseExtension'
  pod 'StatusAlert'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        if ['ReverseExtension'].include? target.name
          config.build_settings['SWIFT_VERSION'] = '4'
        end
      end
    end
  end
end
