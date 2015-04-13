__DIR__ = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path('../lib', __DIR__)
gem_name = File.basename(File.expand_path('..', __DIR__))
require gem_name
