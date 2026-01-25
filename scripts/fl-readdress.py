cf = fontlab.CurrentFont()
delta = 0x1C800 - 0xE000)
for glyph in cf.values():
  unicode = glyph.unicode
  if( (unicode != None) and (unicode >= 0xE000) ):
    unicode = unicode + delta
    newName = "uni%X" % unicode
    print( glyph.name , " => ", newName )
    glyph.unicode = unicode
    glyph.name = newName
