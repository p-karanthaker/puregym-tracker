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
__Clone from GitHub__  
Clone the project in your terminal by typing:  
`git clone https://github.com/p-karanthaker/puregym-tracker.git`  
This will clone it to your current working directory. Change to another directory if you don't want it stored in your current directory.

__Execution permissions__ 
The script needs to be executable in order to run.  
Use command `chmod 744 puregym-tracker.sh` in your terminal to allow execution.  
For Windows this will have to be done in your Cygwin terminal.

__Manually Running the Script__  
It is a good idea to manually run the script once before setting up scheduled tasks.  
The script can be run manually from the terminal/Cygwin by changing directory to its location and entering  
`./puregym-tracker.sh LOGIN_EMAIL LOGIN_PIN`.  
The script should run with no errors and the CSV file should appear in the `logs` directory of the puregym-tracker.  

## Windows (not working)  
In order to get this working on Windows, there is a little more config required since the tracker is a shell script.

__Pre-requisites__  
* Install [Cygwin](https://cygwin.com/install.html) (ensure Curl is installed in the package selection)

__Setting up Task Scheduling__  
1. Edit lines __48 and 49__ of `PureGymTracker.xml`.  
1. Replace `[path\to\run.exe]` and `[path\to\puregym-tracker.sh]` with their real paths.  
1. The default path for `run.exe` is `C:\cygwinXX\bin\run.exe` where `XX` is different based on 32 or 64 bit installations.
1. Import the `PureGymTracker.xml` into Task Scheduler. 
  1. If you want it to run when you're not logged in, select it on the window that pops up.
  1. Click OK when you're done. The task will run within the next 5 minutes.

## Linux and OSX  
__Setting up a CRON job__  
In your terminal enter `crontab -e`. This will open a Vi editor.  
Press `i` to go into insert mode.  
On a new line enter `*/5 * * * * /path/to/puregym-tracker.sh LOGIN_EMAIL LOGIN_PIN`. Make sure the correct full path is provided.  
Press `Esc`, then type `:wq` followed pressing `Enter` to save the file.  
The job will run within the next 5 minutes.
