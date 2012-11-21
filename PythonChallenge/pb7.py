from PIL import Image
im = Image.open("oxygen.png")
pix = im.load()
(width, height) = im.size
for i in range(width):
  if i%7 == 0:
    print chr(pix[i, 50][0]),
    
l = [105,110,116,101,103,114,105,116,121]

print map(chr,l)