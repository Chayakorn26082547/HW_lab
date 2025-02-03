import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def StackControllerTB(dut):
    """Test the StackController by performing push and pop operations."""
    
    dut._log.info("Starting StackController test!")

    # Create and start a clock with a period of 10 ns.
    clock = Clock(dut.Clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Apply reset.
    dut.Reset.value = 1
    dut.Push.value = 0
    dut.Pop.value = 0
    dut.DataIn.value = 0
    dut.RAMDataOut.value = 0
    await Timer(20, units="ns")
    dut.Reset.value = 0
    await RisingEdge(dut.Clk)
    
    # -----------------------------
    # Test 1: PUSH value 0x12 onto the stack.
    # -----------------------------
    dut._log.info("Pushing 0x12 onto the stack")
    dut.DataIn.value = 0x12
    dut.Push.value = 1
    await RisingEdge(dut.Clk)
    dut.Push.value = 0
    await RisingEdge(dut.Clk)
    
    # After one push, the stack counter should be 1.
    assert dut.StackCounter.value.integer == 1, (
        f"Expected StackCounter = 1, got {dut.StackCounter.value.integer}"
    )
    
    # -----------------------------
    # Test 2: PUSH value 0x34 onto the stack.
    # -----------------------------
    dut._log.info("Pushing 0x34 onto the stack")
    dut.DataIn.value = 0x34
    dut.Push.value = 1
    await RisingEdge(dut.Clk)
    dut.Push.value = 0
    await RisingEdge(dut.Clk)
    
    # Now the stack counter should be 2.
    assert dut.StackCounter.value.integer == 2, (
        f"Expected StackCounter = 2, got {dut.StackCounter.value.integer}"
    )
    
    # -----------------------------
    # Test 3: POP from the stack.
    # Expected to pop the last pushed value (0x34).
    # -----------------------------
    dut._log.info("Popping top of stack, expecting 0x34")
    # Simulate the RAM outputting the top-of-stack value.
    dut.RAMDataOut.value = 0x34
    dut.Pop.value = 1
    await RisingEdge(dut.Clk)
    dut.Pop.value = 0
    await RisingEdge(dut.Clk)
    
    # Verify that the StackValue output equals 0x34 (the value popped)
    assert dut.StackValue.value.integer == 0x34, (
        f"Expected StackValue = 0x34, got {hex(dut.StackValue.value.integer)}"
    )
    # The stack counter should now be 1.
    assert dut.StackCounter.value.integer == 1, (
        f"Expected StackCounter = 1, got {dut.StackCounter.value.integer}"
    )
    
    # -----------------------------
    # Test 4: POP again from the stack.
    # Expected to pop the remaining value (0x12).
    # -----------------------------
    dut._log.info("Popping top of stack, expecting 0x12")
    dut.RAMDataOut.value = 0x12
    dut.Pop.value = 1
    await RisingEdge(dut.Clk)
    dut.Pop.value = 0
    await RisingEdge(dut.Clk)
    
    # Verify that the StackValue output equals 0x12.
    assert dut.StackValue.value.integer == 0x12, (
        f"Expected StackValue = 0x12, got {hex(dut.StackValue.value.integer)}"
    )
    # Now the stack should be empty.
    assert dut.StackCounter.value.integer == 0, (
        f"Expected StackCounter = 0, got {dut.StackCounter.value.integer}"
    )
    
    dut._log.info("StackController test complete!")
