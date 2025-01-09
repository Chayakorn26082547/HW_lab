import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

@cocotb.test()
async def SingleBCDTB(dut):
    """Try accessing the design."""
    dut._log.info("Running test!")
    # create the clock
    cocotb.start_soon(Clock(dut.Clk, 1, units="ns").start())
    # Insert your testcase here

    dut._log.info("Test Complete")
