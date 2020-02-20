#  Decode a text to prevent "shoulder surfing", except if the text starts with "HEX:"
import base64, sys

def decode(text):
   if not text.startswith("HEX:"):
       return(text)
   else:
       text2 = text[4:]
       try:
           msg = "warning:"
           dec = []
           enc = base64.urlsafe_b64decode(bytearray.fromhex(text2).decode()).decode()
           for i in range(len(enc)):
              key_c = msg[i % len(msg)]
              dec_c = chr((256 + ord(enc[i]) - ord(key_c)) % 256)
              dec.append(dec_c)
           return("".join(dec))
       except:
           return(text)
        
if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " text")
    else:
        text = sys.argv[1]
    print (decode(text))
