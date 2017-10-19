# puregym-tracker
A simple shell script written to scrape gym activity data from the PureGym website members' area.

Works with:  
* Windows
* Linux
* OSX

The script logs into the PureGym website using your credentials, scrapes the gym activity from the members' webpage. Then writes the data to a CSV file along with a timestamp. Use the data as it is or import it into a graphing tool to visualise the gym activity trends over time!

It can be scheduled to scrape data at any interval you wish. The following instructions schedule the script to run every 5 minutes.

__Important things to note__  
* You must be a member of PureGym in order to use this script
* When the gym activity is above 100, the website will only display '100+ people' so the script will record it as 100 people.
* Some gyms may pad their numbers. As a result you may see, for example, 20 people being logged in the gym when actually nobody is in the gym at that time.
* The script writes to CSV using Unix line endings.

## General Intructions  
Edit lines __8 and 9__ of the script. Replace `YOUR_EMAIL` and `YOUR_PIN` with your PureGym login credentials.
> EMAIL='YOUR_EMAIL'  
> PIN='YOUR_PIN'

## Windows  
In order to get this working on Windows, there is a little more config required since the tracker is a shell script.

__Pre-requisites__  
* [Cygwin](https://cygwin.com/install.html) (ensure Curl is installed in the package selection)

__Setting up Task Scheduling__  

## Linux and OSX  
Place the script wherever you like and make sure that the 'user' role has execution priviliges. 

__Execution permissions__  
Running `chmod 744 puregym-tracker.sh` should do the trick.

__Setting up a CRON job__  


Open a terminal and run the script to ensure it works.
