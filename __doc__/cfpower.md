Community Framework's power system is a powerful framework from which other modders can create machinery that requires power to run. Machines can generate, consume, and store power through this framework.

When using the framework, you should require `cfpower.lua` in a top-level statement and **always** allow the script's `init` function to run first. If you need to implement your own `init` function, you can run the `cfpower.lua` `init` by storing it as a variable (typically named `pInit`) as a top-level statement and calling it in your `init`. You can try to run your own `init` independently, but you will have to set some values and hooks by yourself, which is **not** supported behavior.

Connections between machines using the framework are made through wires, and power is sent between machines through power messages. Each message is a table containing three keys: `power`, `voltage`, and `alternating`. 
The `power` key specifies the amount of power being sent in the message. 
The `voltage` key specifies the voltage of the message; if the recipient's voltage is lower than the voltage of the message, the recipient will discharge all it's stored power and all the power in the message, effectively wasting it.
The `alternating` key specifies if the message is AC (alternating current). When the recipient recieves an AC message, it will attempt to return any power that is not accepted back to the sender in a return message. Voltage still applies to return messages, however, and the sender will discharge all stored power and all the power in the message if the recipient's voltage is greater than it's own.

---

#### `int` cfpower.getMaxPower()

Returns the maximum power capacity.

---

#### `void` cfpower.setMaxPower(`int` power)

Sets the maximum power capacity.

---

#### `int` cfpower.getPower()

Returns the amount of power stored.

---

#### `int` cfpower.setPower(`int` power)

Sets the amount of power stored. Respects maximum power capacity, and returns how much power was added.

---

#### `int` cfpower.createPower(`int` power)

Adds power to the amount of power stored. Respects maximum power capacity, and returns how much power was added.

---

#### `int` cfpower.consumePower(`int` power)

Removes power from the amount of power stored. Returns the amount of power left (negative if not enough power).

---

#### `int` cfpower.pushPower(`int` nodeID, `int` power, [`bool` alternating], [`int` voltage])

Sends power evenly between all objects connected to the specified wire output node through power messages. If the message is not answered with another power message, or is not answered at all, any power consumed when creating that message will be refunded. Returns the number of successful messages, or -1 if a return message caused a discharge.