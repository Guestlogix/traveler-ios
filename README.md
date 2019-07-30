Traveler App

To run this project locally it is necessary to configure the local machine first. 

The project contains a couple of shell scripts in the build phase that inject environment variables into the swift file called Environment.swift, for the scripts to work, it is necessary that local machine is updated to the latest Bash release. 

See this website on how to that: 
https://itnext.io/upgrading-bash-on-macos-7138bd1066ba

Once bash has been upgraded, it will be necessary to copy a text file containing the variables into the Users folder in the local machine. 

That file can be found in this repository: https://github.com/Guestlogix/mobile-environment-variables

Note: The script that injects the environment variables looks for "variables.txt" in the following path: /Users/variables/variables.txt

