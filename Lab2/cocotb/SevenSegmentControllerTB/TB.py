import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

@cocotb.test()
async def SevenSegmentControllerTB(dut):
    """Try accessing the design."""
    dut._log.info("Running test!")
    # create the clock
    cocotb.start_soon(Clock(dut.Clk, 1, units="ns").start())

    #change every 4 clocks
    AN_VALUE = [14,13,11,7]
    # Reset the design
    dut.Reset.value = 1
    await Timer(1.2, units="ns")
    dut.Reset.value = 0
    assert dut.AN.value == 15
    assert dut.Selector.value == 0
    # Insert your testcase here
    await Timer(1.2, units="ns")
    # Test after reset the module should run correctly
    assert dut.AN.value == 0b1110


     # reset
    dut.Reset.value = 0
    await Timer(1.2, units="ns")
    dut.Reset.value = 1
    await Timer(1, units="ns")
    dut.Reset.value = 0
    for i in range(16):
        for j in range(1, 16):
            await Timer(1, units="ns")
            index = j//4
            assert dut.AN.value == AN_VALUE[index]
            assert dut.Selector.value == index
        dut.Reset.value = 1
        await Timer(1, units="ns")
        dut.Reset.value = 0
    
    dut._log.info("Test Complete")
