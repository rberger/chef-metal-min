name 'min_app'
version '0.1.0'

%w(apt).each do | dep |
  depends dep
end
