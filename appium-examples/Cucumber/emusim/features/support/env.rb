require 'appium_lib'
require 'sauce_whisk'
require 'rspec'

Before do | scenario |
  # need to configure env variables for browser
  caps = {
      caps: {
          platformVersion: "#{ENV['platformVersion']}",
          deviceName: "#{ENV['deviceName']}",
          platformName: "#{ENV['platformName']}",
          app: "#{ENV['app']}",
          deviceOrientation: 'portrait',
          name: "#{scenario.feature.name} - #{scenario.name}",
          appiumVersion: '1.9.1',
          browserName: '',
          build: 'Appium-Ruby-Cucumber EmuSim Examples'
      }
  }

  @driver = Appium::Driver.new(caps, true)
  @driver.start_driver
end

# "after all"
After do | scenario |
  sessionid =  @driver.session_id
  jobname = "#{scenario.feature.name} - #{scenario.name}"
  puts "SauceOnDemandSessionID=#{sessionid} job-name=#{jobname}"

  @driver.driver_quit

  if scenario.passed?
    SauceWhisk::Jobs.pass_job sessionid
  else
    SauceWhisk::Jobs.fail_job sessionid
  end
end