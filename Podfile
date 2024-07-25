# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Assignment_Task' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Assignment_Task

  pod 'lottie-ios'
  pod 'HeartButton'
  pod 'SwiftyJSON'
  pod 'SideMenu'
  pod 'SDWebImage'
  
  post_install do |installer|
    
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
    
    installer.pods_project.targets.each do |target|
      
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGN_IDENTITY'] = ''
      end
      
      if ['MaterialCard'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '5.0'
        end
      end
      
    end
  end
  
end
