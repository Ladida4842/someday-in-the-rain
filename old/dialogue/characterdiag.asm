;allowed characters are:
;$0000-$1FFF
;(~8,192 characters, enough to fit the levels 1 & 2 kanji plus some other lol alphabets)
;you can actually have up to $FFFF characters
;but i only included enough GFX for $1FFF
;since 65,536 characters would take up 0x20 hirom banks, or
;about 2MB of data (1/4 of the ROM)
;right now the GFX take up 0x04 hirom banks (0x08 lorom banks)
;considering that they're 1BPP, that's quite alot
;
;unfortunately, not all of the 0-1FFF can be used for characters;
;some are used for control characters. these are listed here:
;
;$0000 * (null)
;$0001 * (start of heading)
;$0002 * (start of text)
;$0003 switches to other character (end of text)
;$0004 ends convo/scene (end of transmission)
;$0005 initiates option select (enquiry)
;$0006 waits for button press (acknowledge)
;$0007 * (bell)
;$0008 * (backspace)
;$0009 * (horizontal tab)
;$000A starts new paragraph/line (NL line feed, new line)
;$000B * (vertical tab)
;$000C * (NP form feed, new page)
;$000D * (carriage return)
;$000E * (shift out)
;$000F * (shift in)
;$0010 * (data link escape)
;$0011 * (device control 1)
;$0012 * (device control 2)
;$0013 * (device control 3)
;$0014 * (device control 4)
;$0015 * (negative acknowledge)
;$0016 * (synchronous idle)
;$0017 * (end of trans. block)
;$0018 * (cancel)
;$0019 * (end of medium)
;$001A * (substitute)
;$001B * (escape)
;$001C * (file separator)
;$001D * (group separator)
;$001E * (record separator)
;$001F * (unit separator)
;$007F * (delete)
;$0081 * (null)
;$008D * (null)
;$008F * (null)
;$0090 * (null)
;$009D * (null)

cleartable
%org($C80000)
Diag_Fari:
incsrc Fari/fari.asm