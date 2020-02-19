# Encode a text to prevent "shoulder surfing"
import base64, sys
if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " text")
else:
    enc = []
    msg = "warning:"
    for i, ch in enumerate(sys.argv[1]):
        key_c = msg[i % len(msg)]
        enc_c = chr((ord(ch) + ord(key_c)) % 256)
        enc.append(enc_c)
    print ("HEX:" + base64.urlsafe_b64encode("".join(enc).encode('utf8')).hex())
