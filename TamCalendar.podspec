Pod::Spec.new do |s|
    s.name          =  'TamCalendar'
    s.version       =  '2.0.0'
    s.summary       =  'A simple calendar control'
    s.homepage      =  'https://github.com/thatha123/TamCalendar'
    s.license       =  'MIT'
    s.authors       = {'Tam' => '1558842407@qq.com'}
    s.platform      =  :ios,'8.0'
    s.source        = {:git => 'https://github.com/thatha123/TamCalendar.git',:tag => s.version}
    s.source_files  =  'TamCalendarTest/TamCalendar/**/*.{h,m}'
    s.resource      =  'TamCalendarTest/TamCalendar/Resources'
    s.requires_arc  =  true
end

