# Testing Setup

## Equipment
### Motor
#### Hennkwell P/N PZ222GR9120R-084BBH
- https://www.mpja.com/24VDC-142RPM-Gearhead-Motor/productinfo/35772%20MD/

#### Dynamo/Torque Sensor
DYN-200
- https://caltsensor.com/product/rotary-torque-sensors-dyn-200/
- https://www.ato.com/Content/doc/Digita-rotary-torque-sensor-user-manual-ATO-TQS-DYN-200.pdf

Notes
- Measures torque/RPM and calculates mechanical power exerted
- Can output torque via SIG (±5V/±10V/4-20mA) and RPM as 60 pulses per rotation
- Has communication and control w/ RS485
- Does not have any calibration/measurement guarantees (Don't even have actual specs... assuming it's this one)

Pins
1. Red, PWR (+24V)
2. Black, PWR (0V)
3. Green, SIG OUT (±5V/±10V/4-20mA)
4. White, SIG GND
5. Yellow, RS485 A
6. Blue, RS485 B
7. Orange, RPM+
8. Gray, RPM-
9. Braided wire, shielded line (It can't be connected to torque sensor housing)

### Power Supply
#### HANMATEK HM305 (provided)
- https://www.amazon.com/Adjustable-Disable-Variable-Switching-Digital/dp/B0852JZQZR?th=1
- https://m.media-amazon.com/images/I/91-ByTxCjvL.pdf

Notes
- Is a pretty standard power supply (don't have any explicit documentation)


#### Siglent SPD3303X-E
- https://siglentna.com/power-supplies/spd3303x-spd3303x-e-series-programmable-dc-power-supply/

Notes
- Good DC power supply... 
- Has all the software needed for direct control and data acquisition over USB


### Batteries
#### LIPOs
add product number and such...





### Oscilliscope and/or multimeter
Have the Siglent oscilliscope but would need to acquire desktop multimeter in the lab




# Testing Procedure
## Loading/Torque
### Method 1: Opposing Motor
- Use a motor on the other side of the sensor that applies adjustable torque (i.e. applied voltage) counteracting the original motor
- Most adjustable/controllable
- Requires use of the other/a different motor
- (This is not good for the motor... especially because of planetary gearbox)

If used we could likely use the same 3D printed designs for the other motor on the opposite side... 

### Method 2: Friction
- Create (print?) a friction based mechanism
- Would be less adjustable (fine) but certainly not consistent
- A few different methods/ideas...
  - disk brake style (3D printed)
  - Clamping direct on shaft

## Supplying Power
### Power Supply method
Do the testing... Much simpler as when using our power supply we have the direct voltage and current

### Batteries
The same testing... but need to measure Voltage/Current w/ something
#### Osciliscope w/ resistors
- This method is a pretty standard for small electrical circuits... but issues arise when doing it for larger currents
- Adds additional impedance to the system (both the resistance and inductance causing power losses) 
- Resistor options
  - Use a power resistor (need to acquire)
  - Use many standard resistors in parallel (lots of issues)

#### Multimeter current (& voltage) measurement
- Needs to be rated for enough current
  - Would blow most fuses is we want to run any longer tests
- Would want desktop one that connects to pc for data acquisition
  - Borrow from another lab (takes longer... but likely tomorrow/monday)
  - Not certain it'd be able to handle the power
    






