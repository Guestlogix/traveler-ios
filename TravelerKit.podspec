Pod::Spec.new do |spec|
  spec.name         = 'TravelerKit'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'Apache' }
  spec.homepage     = 'https://github.com/Guestlogix/traveler-ios'
  spec.authors      = { 'Ata N' => 'anamvari@guestlogix.com' }
  spec.summary      = 'Traveler Swift Core SDK'
#  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :tag => '0.1.0' }
  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :branch => 'master' }
  spec.swift_version = "4.2"

  spec.source_files = "traveler-swift-core/TravelerKit/**/*.{swift}"
  spec.ios.deployment_target = '12.1'
  spec.module_name = "TravelerKit"

end
