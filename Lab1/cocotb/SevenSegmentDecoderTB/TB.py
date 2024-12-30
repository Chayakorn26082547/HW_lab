import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def MultiplexerTB(dut):
    """Try accessing the design."""
    dut._log.info("Running test!")
    # create a testbench here
    
    dut._log.info("Test Complete")
