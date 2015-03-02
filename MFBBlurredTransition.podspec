Pod::Spec.new do |s|
  s.name             = "MFBBlurredTransition"
  s.version          = "0.2.0"
  s.summary          = "Present modal view controllers with blur behind them."
  s.description      = "Present modal view controllers with blur behind them, using iOS 7 transitioning APIs. Based on [KLViewControllerTransitions](https://github.com/klundberg/KLViewControllerTransitions)"
  s.homepage         = "https://github.com/marcelofabri/MFBBlurredTransition"
  s.license          = 'MIT'
  s.author           = { "Marcelo Fabri" => "me@marcelofabri.com" }
  s.source           = { :git => "https://github.com/marcelofabri/MFBBlurredTransition.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/marcelofabri_'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.dependency 'UIView+UIImageEffects'
  s.dependency 'CGFloatType'
end
