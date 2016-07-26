module Pages
  class BasePage
    include Capybara::DSL

    def initialize(session, extras={})
      @environment = extras[:environment] || ::ExampleApp::Environment.current
      @parameters = Hashie::Mash.new(extras)
      @session = session
    end

    def anchor 
      raise 'each child class need to define its own locators'
    end

    def clear_all_cookies
      browser = Capybara.current_session.driver.browser
      browser.manage.delete_all_cookies
    end

    def refresh_page
      @session.driver.browser.navigate.refresh
    end

    def has_text?(text)
      @session.has_text?(text)
    end

    def has_selector?(selector, visiblility = false)
      @session.has_selector?(selector, :visible => visiblility)
    end

    def has_alert_message?
      has_selector?('.alert')
    end

    def the_current_page?
      return @session.has_selector?(anchor, wait: 1) if anchor
    end

    def not_the_current_page?
      return @session.has_no_selector?(anchor, wait: 1) if anchor
    end

    def current_url
      @session.current_url
    end

    def visit
      @session.visit url
    end

    def select_option_by_value(value, locator)
      @session.within locator do
        find("option[value='#{value}']").click
      end
    end

    def select_by_index(locator, index)
      @session.within locator do
        find('option:nth-child(' + index +')').click
      end
    end

    def select_option_by_label(value, locator)
      @session.within locator do
        find("option[label='" + value + "']").click
      end
    end

    def find_all(locator)
      @session.all locator
    end

    def find(name, visiblility = true)
      @session.find(name, visiblility)
    end

    def find_by_text(tag, text)
      @session.find(tag, :text => text)
    end

    def click_within_element(element, locator)
      @session.within element do
        find(locator).click
      end
    end

    def set_text_on_all_fields(fields={})
      fields.each { |key, value| set_text(key, value) }
    end

    def set_text(name, value)
      find(name).set value
    end

    def click(locator, visiblility = true)
      find(locator, visiblility).click
    end

    def select_by_text(tag, text)
      find_by_text(tag, text).click
    end

    def within_component(&block)
      @session.within root_selector, &block
    end

    def execute_script(script)
      @session.execute_script script
    end

    def displayed?(location)
      begin
        if has_selector? location
          find(location).displayed
        end
        true
      rescue => exception
        false
      end
    end

  end
end
