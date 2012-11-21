import urllib
import re

baseUrl = "http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing="
nr = "12345"
for i in range(400):
  result = urllib.urlopen(baseUrl+nr).read()
  print i, result
  match = re.search("the next nothing is [0-9]+",result);
  if match:
    nr = re.search("[0-9]+", match.group()).group()
  else:
    nr = str(int(nr)/2)
  
