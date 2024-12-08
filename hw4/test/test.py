import unittest
import os
import sys

from pathlib import Path
sys.path.append(str(Path('.').absolute().parent))
import src.la_monitor

class TestLoadAverageInfo:
  @allure.feature('Random dog')
  def test_get_load_average(self):
    current_la = src.la_monitor.get_load_average()

    self.assertTrue(len(current_la) == 3)

    for la in current_la:
        self.assertIsInstance(la, float)

    for la in current_la:
        self.assertTrue(la > 0)

# if __name__ == '__main__':
#     unittest.main()