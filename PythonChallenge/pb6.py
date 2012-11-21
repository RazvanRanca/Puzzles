import re
import zipfile

base = "channel/"
cur = 90052
c = 0
with zipfile.ZipFile('channel.zip', 'r') as myzip:
  while True:
    with open(base + str(cur) + ".txt", 'r') as f:
      c += 1
      file = f.read()
      print myzip.getinfo(str(cur) + ".txt").comment,
      match = re.search("Next nothing is [0-9]+",file);
      cur = int(re.search("[0-9]+", match.group()).group())


  