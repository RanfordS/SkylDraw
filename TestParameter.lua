require "MetaType"
P = require "Parameter"

a = P.new "a"
b = P.new "b"
c = 2*a + a^b
print (c:evaluate {a = 2, b = 3})

d = P.call (math.sqrt, a)
print (d:evaluate {a = 4})

