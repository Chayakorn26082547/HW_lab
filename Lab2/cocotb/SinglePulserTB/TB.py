import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

@cocotb.test()
async def SinglePulserTB(dut):
    """Try accessing the design."""
    dut._log.info("Running test!")
    # create the clock
    cocotb.start_soon(Clock(dut.Clk, 1, units="ns").start())
    # Insert your testcase here
    
    # Reset the DUT
    dut.Reset.value = 1
    dut.DataIn.value = 0
    await Timer(1.2, units="ns")  # Wait for 2 clock cycles
    dut.Reset.value = 0
    
    # Test Case 1: DataIn is 0, expect no pulse
    dut.DataIn.value = 0
    await Timer(1, units="ns")
    assert dut.DataOut.value == 0, "Test Case 1 Failed: DataOut should be 0 when DataIn is 0"

    # Test Case 2: Rising edge on DataIn, expect a pulse
    dut.DataIn.value = 1
    await Timer(1, units="ns")
    assert dut.DataOut.value == 1, "Test Case 2 Failed: DataOut should be 1 on rising edge of DataIn"

    # Test Case 3: DataIn remains 1, expect no additional pulse
    await Timer(1, units="ns")
    assert dut.DataOut.value == 0, "Test Case 3 Failed: DataOut should be 0 when DataIn remains high"

    # Test Case 4: Another rising edge after falling edge, expect a pulse
    dut.DataIn.value = 0
    await Timer(1, units="ns")
    dut.DataIn.value = 1
    await Timer(1, units="ns")
    assert dut.DataOut.value == 1, "Test Case 4 Failed: DataOut should be 1 on the second rising edge of DataIn"
    await Timer(1, units="ns")
    assert dut.DataOut.value == 0, "Test Case 4 Failed: DataOut should be 0 after the second rising edge of DataIn"
    
    # Test Case 5: Reset while DataIn is 1
    dut.Reset.value = 1
    await Timer(1, units="ns")
    dut.Reset.value = 0
    assert dut.DataOut.value == 0, "Test Case 5 Failed: DataOut should reset to 0 after Reset is asserted"

    #test case 6: For loop test
    dut.DataIn.value = 0
    await Timer(1, units="ns")
    for j in range(10):
        for i in range(10):
            dut.DataIn.value = 1
            await Timer(1, units="ns")
            assert dut.DataOut.value == 1, "Test Case 6 Failed: DataOut should be 1 on rising edge of DataIn"
            await Timer(1, units="ns")
            assert dut.DataOut.value == 0, "Test Case 6 Failed: DataOut should be 0 after the rising edge of DataIn"
            dut.DataIn.value = 0
            await Timer(1, units="ns")
            assert dut.DataOut.value == 0, "Test Case 6 Failed: DataOut should be 0 when DataIn is 0"
        dut.Reset.value = 1
        await Timer(1, units="ns")
        dut.Reset.value = 0
        await Timer(1, units="ns")
        assert dut.DataOut.value == 0, "Test Case 6 Failed: DataOut should reset to 0 after Reset is asserted"


    dut._log.info("Test Complete")
