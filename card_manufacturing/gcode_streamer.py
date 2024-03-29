import time
from typing import List
from functools import partial
import signal
import sys
import re
import argparse
from pathlib import Path
import logging
import plac
import serial

# Uncomment the line below to mock the serial port
# import card_manufacturing.fake_serial as serial

RX_BUFFER_SIZE = 128


# Global variables
g_consumed = 0
g_error = 0
g_sent = 0
g_buffer: List[int] = []
is_absolute = False


def clean(conn: serial.Serial):
    """Clean the serial port from 

    Args:
        conn (serial.Serial): The serial connection to clean.
    """
    global g_consumed
    global g_error
    global g_sent
    global g_buffer
    while g_sent > g_consumed:
        grbl_resp = conn.readline().strip().decode()
        # Debug response
        if grbl_resp.find('ok') < 0 and grbl_resp.find('error') < 0:
            logging.info(f"MSG: '{grbl_resp}'")
        else:  # Interpreted GCode response
            if grbl_resp.find('error') >= 0:
                logging.warning(f"GCode Error: {grbl_resp}")
                g_error += 1
            g_consumed += 1
            logging.info(f"REC<{g_consumed}: '{grbl_resp}'")
            del g_buffer[0]


def send_and_log(conn, data):
    if isinstance(data, str):
        data = data.encode()
    global g_consumed
    conn.write(data)
    resp = conn.readline().decode()
    logging.info(f"REC<{g_consumed}: '{resp}'")


def signal_handler(conn, signal, frame):
    global g_consumed
    global g_error
    global g_sent
    global is_absolute
    clean(conn)

    logging.info("Returning Home")
    if not is_absolute:
        send_and_log(conn, "G90\n".encode())
    send_and_log(conn, "G0X0Y0Z0\n".encode())
    send_and_log(conn, "M5\n")
    send_and_log(conn, "$32=0\n")
    sys.exit(0)


@plac.pos('file', 'the gcode file to stream', type=Path)
@plac.annotations(
    device_file=(
        'the serial device path'
    ),
    baud_rate=(
        'the baud rate of the device to stream to',
        'option', 'br', int),
    zero_cnc=(
        'zero the CNC to cut from it\'s current position.',
        'flag', 'zc'
    ),
    log_level=(
        'the log level for the program. Options are "DEBUG",'
        '"INFO", "WARNING", "ERROR", and "CRITICAL".', 'option',
        'll', str, ["DEBUG", "INFO", "WARNING", "ERROR",
                    "CRITICAL"])
)
def gcode_streamer(
    file: Path,
    device_file: str,
    baud_rate: int = 115200,
    zero_cnc: bool = False,
    log_level: str = "INFO"
):
    """Stream GCODE to a GRBL device using an aggressive streaming protocol
    which attempts to keep the buffer on the machine as full as possible.
    """
    global g_consumed
    global g_error
    global g_sent
    global g_buffer
    global is_absolute
    logging.basicConfig()
    logging.getLogger().setLevel(log_level)

    with serial.Serial(device_file, baud_rate) as s_conn:
        signal.signal(signal.SIGINT, partial(signal_handler, s_conn))

        logging.info("Initializing grbl")
        s_conn.write("\r\n\r\n".encode())
        resp = s_conn.readline()

        time.sleep(2)
        s_conn.flushInput()
        s_conn.write("$X\n".encode())
        resp = s_conn.readline().strip().decode()
        logging.info(f"Unlocked: {resp}")

        if zero_cnc:
            send_and_log(s_conn, "G92X0Y0Z0\n")
            send_and_log(s_conn, "G10L20P1X0Y0Z0\n")
            logging.info(f"Zeroed: {resp}")

        t_start = time.time()
        with open(file, mode='r') as f:

            for i, line in enumerate(f):
                line = re.sub('\s|\(.*?\)', '', line).upper()

                g_buffer.append(len(line))

                # If the buffer is full, wait for a response
                while sum(g_buffer) >= RX_BUFFER_SIZE - 1 | s_conn.inWaiting():
                    grbl_resp = s_conn.readline().strip().decode()

                    # Debug response
                    if grbl_resp.find('ok') < 0 and grbl_resp.find('error') < 0:
                        logging.info(f"MSG: '{grbl_resp}'")
                    else:  # Interpreted GCode response
                        if grbl_resp.find('error') >= 0:
                            logging.warning(f"GCode Error: {grbl_resp}")
                            g_error += 1
                        g_consumed += 1
                        logging.info(f"REC<{g_consumed}: '{grbl_resp}'")
                        del g_buffer[0]

                s_conn.write(f'{line}\n'.encode())
                if line.find('G90') >= 0:
                    is_absolute = True
                if line.find('G91') >= 0:
                    is_absolute = False
                g_sent = i
                logging.info(f"SND>{i}: '{line}'")

            clean(s_conn)

        # We have no way of knowing when gcode is done being executed, so we just
        # wait for a bit. Optionally, we could wait for user input, but this
        # is more automated.
        time.sleep(5)
        t_end = time.time()
        logging.info("G-code streaming finished!")
        logging.info(f"Time elapsed: {t_end - t_start}")


if __name__ == '__main__':
    plac.call(gcode_streamer)
