source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

target 'PartyApp' do
    pod 'MGSwipeTableCell', '~> 1.5.3'
    pod 'pop', :git => 'https://github.com/facebook/pop.git'
    pod 'RETableViewManager', :git => 'https://github.com/Skornos/RETableViewManager.git'
    pod 'NMRangeSlider', :git => 'https://github.com/muZZkat/NMRangeSlider.git'
    pod 'XMLDictionary', '~> 1.4'
        
    pod 'Onboard', :git => 'https://github.com/Skornos/Onboard.git'
    pod 'CocoaLumberjack'
    
    # clean status bar from the screenshots on simulator
    pod 'SimulatorStatusMagic', :configurations => ['Debug']     
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_NO_COMMON_BLOCKS'] = 'NO'
        end
    end
end
