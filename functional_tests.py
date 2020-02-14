import os
import unittest

from selenium import webdriver


class TestHome(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Chrome()
        return super().setUp()

    def tearDown(self):
        self.browser.stop_client()
        self.browser.quit()
        os.system('killall -e /usr/lib/chromium/chromium')
        os.system('killall -e chromedriver')
        return super().tearDown()

    def test_overview_of_home_page(self):
        # Gary goes to the home page of Worst Practice Django.
        self.browser.get('http://localhost:5678')

        # Gary notice the title is "Worst Practice Django".
        self.assertEqual('Worst Practice Django', self.browser.title)
        self.fail("Finish all tests")


if __name__ == '__main__':
    unittest.main(warnings='ignore')
