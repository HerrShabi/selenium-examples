module Pages
  module ExampleApp
    class LoginPage < BasePage

      PAGE_ANCHOR = '.i-am-the-logo-css'
      WELCOME_TEXT = 'Hi and welcom to our system!'

      def anchor
        PAGE_ANCHOR
      end

      def logged_in?
        has_selector? '.logout'
      end

      def is_loaded?
        has_text? WELCOME_TEXT
      end

      def url
        environment.url + '#/login'
      end

      def open
        visit
        self
      end

      def enter_credentials(user)        
        find('.email').set(user.email)
        find('.password').set(user.password)
      end

      def submit_login
        find('input[type=submit]').click
      end

      def login(user)
        enter_credentials user
        submit_login
        Auctionata::Pages::ExampleApp::HomePage.new(@session)
      end
    end
  end
end
