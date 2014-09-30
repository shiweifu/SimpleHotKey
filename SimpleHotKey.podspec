Pod::Spec.new do |s|
  s.name         = 'SimpleHotKey'
  s.version      = '0.1'
  s.summary      = 'easy to register global hotkey in OSX'
  s.homepage     = 'https://github.com/shiweifu/SimpleHotKey'
  s.author       = { 'shiweifu' => 'shiweifu@gmail.com' }
  s.license      = 'LICENSE' 
  s.source       = { :git => 'https://github.com/shiweifu/SimpleHotKey' }
  s.source_files = ['HotKeyDemo/SPHotKey.{h,m}', 'HotKeyDemo/SPHotKeyManager.{h,m}']
  s.requires_arc = false
  s.platform     = :osx
  s.framework    = ['Carbon', 'Cocoa']
end

