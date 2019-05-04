# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'AZDMV' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_modular_headers!

  # Pods for AZDMV
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Kingfisher'


  pod 'AcknowList'
  pod 'BulletinBoard'
  pod 'CHTCollectionViewWaterfallLayout/Swift', :git=>'https://github.com/ApolloZhu/CHTCollectionViewWaterfallLayout'
  pod 'ReverseExtension'
  pod 'StatusAlert'
  pod 'WhatsNew'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      if ['ReverseExtension'].include? target.name
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4'
          end
      end
  end
end
