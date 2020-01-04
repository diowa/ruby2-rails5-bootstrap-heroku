# frozen_string_literal: true

class SeleniumBrowserErrorReporter
  def self.call(page)
    new(page).report!
  end

  def initialize(page)
    self.page = page
  end

  def report!
    return if severe_errors.none?

    report = error_report_for(severe_errors)
    raise Selenium::WebDriver::Error, "There #{severe_errors.count == 1 ? 'was' : 'were'} #{severe_errors.count} "\
          "JavaScript error#{severe_errors.count == 1 ? '' : 's'}:\n\n#{report}"
  end

  private

  attr_accessor :page

  def error_report_for(logs)
    logs
      .map(&:message)
      .map { |message| message.gsub('\\n', "\n") }
      .join("\n\n")
  end

  def logs
    @logs ||= page.driver.browser.manage.logs.get(:browser)
  end

  def severe_errors
    @severe_errors ||= logs.select { |log| log.level == 'SEVERE' }
  end
end
