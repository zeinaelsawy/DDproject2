# DDproject2
#Digital Alarm Clock Design and Implementation
Overview
This project revolves around the design and implementation of a digital alarm clock using a BASYS3 FPGA development board, leveraging the Verilog programming language. The clock operates under two main modes, "clock/alarm" and "adjust," managed by a finite state machine (FSM). User interactions through simple push buttons allow for setting both the alarm and the current time, with additional visual cues provided by a 7-segment display, blinking decimal points, and LEDs.
Features
Two Main Operating Modes: Toggle between clock display and alarm settings.
Finite State Machine: Manages state transitions for setting time and alarms.
User Interactions: Utilize buttons to adjust time and set alarms.
Visual and Audio Cues: Includes a 7-segment display and sound output when the alarm is triggered.
Robust Design: Implemented using Verilog to ensure precise control and timing.
State Descriptions and Transitions
Our implementation divides the clock's functionality into several states:
Clock/Alarm: Default mode displaying current time or alarm.
Adjust Time Hour/Minute: Allows incrementing or decrementing the time.
Adjust Alarm Hour/Minute: Allows setting the alarm time.
Transitions between these states are managed through user inputs, with each state capable of modifying specific parameters or triggering the alarm.
Implementation Details
Mealy Machine Approach: Outputs are determined during state transitions, not by the states themselves.
Event-Driven Design: Each state response to button presses, adjusting various parameters such as time and alarms.
LED and Display Management: Uses LEDs to indicate active settings and a 7-segment display for time and alarm display.
Error Handling
The system includes robust error handling to manage invalid inputs or faulty state transitions, ensuring the clock maintains accurate functionality under various conditions.


Validation and Testing
We conducted thorough testing and validation, including:
Module Testing: Each component, such as the debouncer and clock divider, was individually tested.
State Transition Verification: The FSM's transitions were extensively tested to ensure accurate operation.
Hardware Implementation: The entire system was deployed on a BASYS3 FPGA board to verify hardware compatibility and functionality.
