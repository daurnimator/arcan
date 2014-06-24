-- input_target
-- @short: Forwards the specified event table to a target frameserver.
-- @inargs: inputtbl, dstobj
-- @outargs:
-- @longdescr: Any table that is formatted with the same / similar fields- as
-- those received from _input_event can be directly forwarded to any frameserver
-- using this function. Argument order is agnostic (type determines argument)
-- and it is also aliased as target_input.
-- @group: targetcontrol
-- @cfunction: arcan_lua_targetinput
-- @related: target_input

