Pod::Spec.new do |spec|
  spec.name         = 'TravelerStripe'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'Apache' }
  spec.homepage     = 'https://github.com/Guestlogix/traveler-ios'
  spec.authors      = { 'Ata N' => 'anamvari@guestlogix.com' }
  spec.summary      = 'Traveler Stripe Payment Provider'
#  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :tag => '0.1.0' }
  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :branch => 'master' }
  spec.swift_version = "5.0"

  spec.platform = :ios
  spec.ios.deployment_target = '11.4'
  spec.framework = "UIKit"
  spec.dependency 'TravelerKit'
  spec.dependency 'TravelerKitUI'
  spec.dependency 'Stripe', '17.0.2'
  spec.source_files = "traveler-ios-stripe/TravelerStripePaymentProvider/**/*.{swift}"
  spec.module_name = "TravelerStripePaymentProvider"
end
