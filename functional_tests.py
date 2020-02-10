import logging
import os

from selenium import webdriver

logger = logging.getLogger(__name__)

browser = webdriver.Chrome()
browser.get('http://localhost:5678')
logger.error('title: ' + browser.title)
assert 'Django' in browser.title, "'Django' is not in title"
browser.stop_client()
browser.quit()

os.system('killall -e /usr/lib/chromium/chromium')
os.system('killall -e chromedriver')
