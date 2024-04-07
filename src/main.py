import re
import time
from functools import lru_cache
from os import getenv
from subprocess import CalledProcessError, run

from prometheus_client import Summary, start_http_server


class TemperatureNotFoundError(Exception):
    """Exception raised when not temperature is found in the arcconf output"""


class Arcconf:
    """Class to communicate with the Adaptec RAID controller using arcconf"""

    __hba: int

    def __init__(self, hba: int) -> None:
        self.__hba = hba

    @lru_cache(maxsize=1)
    def __get_arcconf_report(self, timestamp: float) -> str:
        del timestamp  # Unused, for cache invalidation
        command = ("/bin/arcconf", "getconfig", str(self.__hba), "AD")
        process = run(args=command, capture_output=True, encoding="utf-8", check=True)
        return process.stdout

    def __extract_temperature_line(self, arcconf_output: str) -> str:
        lines = arcconf_output.split("\n")
        return [line for line in lines if "Temperature" in line][0]

    def __extract_temperature_str(self, line: str) -> str:
        celsius_temperature_regex = r"([0-9]{1,3})\s*C"
        return re.search(celsius_temperature_regex, line).group(1)

    def get_temperature(self) -> int:
        timestamp = int(time.time())
        try:
            arcconf_report = self.__get_arcconf_report(timestamp)
            temperature_line = self.__extract_temperature_line(arcconf_report)
            temperature_str = self.__extract_temperature_str(temperature_line)
            return int(temperature_str)
        except (CalledProcessError, IndexError) as error:
            raise TemperatureNotFoundError() from error


if __name__ == "__main__":
    # Options
    hba = int(getenv("HBA", "1"))
    port = int(getenv("PORT", "80"))
    interval = float(getenv("INTERVAL", "1.0"))

    # Setup
    arcconf = Arcconf(hba)
    start_http_server(port)
    temperature_summary = Summary(
        "temperature", "Temperature of the RAID controller in degrees Celsius"
    )

    # Loop
    while True:
        temperature = arcconf.get_temperature()
        temperature_summary.observe(temperature)
        time.sleep(interval)
