The cfutil table exists as an extension of the util table. If you require cfutil, you don't need to require util as it's already required.

---

#### `void` cfutil.printTable(`table` table)

Prints the contents of the given table to the log.

---

#### `void` cfutil.deepPrintTable(`table` table)

Prints the contents of the given table and all tables contained within to the log.

---

#### `string` cfutil.numToHex(`int` num)

Converts the given integer into a hexidecimal value.

--- 

#### `string` cfutil.percToHex(`int` num)

Converts the given percentage value into a hexidecimal value. Clamped between 0 and 1.

---

#### `int` cfutil.hexToNum(`string` hex)

Converts the given hexidecimal value into an integer.

---

#### `string` cfutil.fadeHex(`string` hex, `string` fade, `int` amount, `string` target)

Creates a 'fade' between the two given hexidecimal values, indicated by the given amount and limited by the target.

---

#### `int` cfutil.rollDice(`int` dice, `int` sides, `int` mod)

Simulates a dice roll with the given number of dice, sides per dice, and a flat modifier.

----

#### `table` cfutil.mergeTable(`table` t1, `table` t2)

Merges the two given tables. Unlike util.mergeTable, it combines arrays instead of overriding them.

----

#### `bool` cfutil.isArray(`table` tbl)

Returns true if the given table is an array (no keys, only values).

----

#### `bool` cfutil.positionWithinBounds(`table` target, `table` startPoint, `table` endPoint)

Returns true if the target position is within the box created by the start and end points.

----

#### `bool` cfutil.positionWithinBox(`table` target, `table` box)

Returns true if the target position is within the box coordinates.