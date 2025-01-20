import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

@cocotb.test()
async def SingleBCDTB(dut):
    """Try accessing the design."""
    dut._log.info("Running test!")
    # create the clock
    cocotb.start_soon(Clock(dut.Clk, 1, units="ns").start())

    # Reset the design
    dut.Reset.value = 1
    dut.Trigger.value = 0
    dut.Cin.value = 0
    await Timer(1.2, units="ns")
    dut.Reset.value = 0
    assert dut.DataOut.value == 0
    assert dut.Cout.value == 0
    # Insert your testcase here

    dut.Trigger.value = 0
    dut.Reset.value = 0
    dut.Cin.value = 0
    await Timer(1.2, units="ns")
    # Test Case 1: Reset functionality
    dut.Reset.value = 1
    await Timer(1, units="ns")
    dut.Reset.value = 0
    assert dut.Cout.value == 0, f"Reset failed, Cout = {dut.Cout.value}"
    assert dut.DataOut.value == 0, f"Reset failed, DataOut = {dut.DataOut.value}"

    # Test Case 2: Incrementing the BCD value
    dut.Trigger.value = 1
    dut.Cin.value = 0
    for j in range(5):
        dut.Reset.value = 1
        await Timer(1, units="ns")
        assert dut.Cout.value == 0, f"Reset failed, Cout = {dut.Cout.value}"
        assert dut.DataOut.value == 0, f"Reset failed, DataOut = {dut.DataOut.value}"
        dut.Reset.value = 0
        for i in range(29):
            # Compute expected values
            expect_output = (i+1) % 10
            expect_cout = ((i+1) % 10 == 0 and (i+1) != 0)  # Carry out for every 10th increment
            assert dut.Cout.value == expect_cout, f"Carry out failed, Cout = {dut.Cout.value}"
            await Timer(1, units="ns")

            

            assert dut.DataOut.value == expect_output, f"DataOut failed, DataOut = {dut.DataOut.value}"

    # Test Case 3: Incrementing the BCD value with Cin = 1
    dut.DataOut.value = 0b1001
    dut.Cin.value = 1
    dut.Trigger.value = 1
    assert dut.Cout.value == 1, f"Carry out failed, Cout = {dut.Cout.value}"
    await Timer(1, units="ns")
    assert dut.DataOut.value == 1, f"DataOut failed, DataOut = {dut.DataOut.value}"



    dut._log.info("Test Complete")
