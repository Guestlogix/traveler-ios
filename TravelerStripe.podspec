Pod::Spec.new do |spec|
  spec.name         = 'TravelerStripe'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'Apache' }
  spec.homepage     = 'https://github.com/Guestlogix/traveler-ios'
  spec.authors      = { 'Ata N' => 'anamvari@guestlogix.com' }
  spec.summary      = 'Traveler Stripe Payment Provider'
#  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :tag => '0.1.0' }
  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :branch => 'master' }
  spec.swift_version = "4.2"

  spec.platform = :ios
  spec.ios.deployment_target = '12.1'
  spec.framework = "UIKit"
  spec.dependency 'TravelerKit'
  spec.dependency 'TravelerKitUI'
  spec.dependency 'Stripe'
  spec.source_files = "traveler-ios-stripe/TravelerStripePaymentProvider/**/*.{swift}"
  spec.module_name = "TravelerStripePaymentProvider"
end
