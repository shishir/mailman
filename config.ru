#!/usr/bin/env ruby
require 'rack'
load 'app/service/request_controller.rb'
run RequestController.new