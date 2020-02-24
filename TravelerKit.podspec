Pod::Spec.new do |spec|
  spec.name         = 'TravelerKit'
  spec.version      = '0.1.1'
  spec.license      = { :type => 'Apache' }
  spec.homepage     = 'https://github.com/Guestlogix/traveler-ios'
  spec.authors      = { 'Ata N' => 'anamvari@guestlogix.com' }
  spec.summary      = 'Traveler Swift Core SDK'
#  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :tag => '0.1.0' }
  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :branch => 'master' }
  spec.swift_version = "5.0"

  spec.source_files = "traveler-swift-core/TravelerKit/**/*.{swift}"
  spec.ios.deployment_target = '11.4'
  spec.module_name = "TravelerKit"

end
