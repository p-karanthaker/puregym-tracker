# puregym-tracker
### NB. I am no longer a member at PureGym so do not know if this works anymore. A nice solution to check out may be [puregym-attendance](https://github.com/2t6h/puregym-attendance)
Simple scripts written to scrape gym activity data from the PureGym website members' area.

Works with:  
* Windows (requires PowerShell 3 or higher)
* Linux
* OSX

The script logs into the PureGym website using your credentials, scrapes the gym activity from the members' webpage. Then writes the data to a CSV file along with a timestamp. Use the data as it is or import it into a graphing tool to visualise the gym activity trends over time!

It can be scheduled to scrape data at any interval you wish. The following instructions schedule the script to run every 5 minutes.

__Important things to note__  
* You must be a member of PureGym in order to use these scripts.
* When the gym activity is above 100, the website will only display '100+ people' so the script will record it as 100 people.
* Some gyms may pad their numbers. As a result you may see, for example, 20 people being logged in the gym when actually nobody is in the gym at that time.
* The script writes to file using Unix line endings for the Bash script and Windows line endings for the PowerShell script.

## General Intructions  
__Clone from GitHub__  
Clone the project in your terminal by typing:  
`git clone https://github.com/p-karanthaker/puregym-tracker.git`  
This will clone it to your current working directory. Change to another directory if you don't want it stored in your current directory.

__Execution permissions__ 
The script needs to be executable in order to run.  
Use command `chmod 744 puregym-tracker.sh` in your terminal to allow execution.  
For Windows you may need to set your execution policy for PowerShell.

__Manually Running the Script__  
It is a good idea to manually run the script once before setting up scheduled tasks.  

For Bash, the script can be run from the terminal by changing directory to its location and entering  
`./puregym-tracker.sh LOGIN_EMAIL LOGIN_PIN`.  

For Windows, the script can be run from a PowerShell console by changing directory to its location and entering
`.\puregym-tracker.ps1 -email LOGIN_EMAIL -pin LOGIN_PIN`.

The script should run with no errors and the CSV file should appear in the `logs` directory of the puregym-tracker.  

## Windows  
__Setting up Task Scheduling__  
1. Import the `puregym-tracker.xml` into Task Scheduler.  
  1. If you want it to run when you're not logged in, select the radio button on the window that pops up.  
  1. Go to the `Actions` tab and edit the action listed.
  1. In `Add arguments`, replace `path\to\puregym-tracker.ps1` with its real path.  
  1. Replace `LOGIN_EMAIL` and `LOGIN_PIN` with your PureGym login credentials.  
  1. Click OK and OK again when you're done. The task will run within the next 5 minutes.  

## Linux and OSX  
__Setting up a CRON job__  
In your terminal enter `crontab -e`. This will open a Vi editor.  
Press `i` to go into insert mode.  
On a new line enter `*/5 * * * * /path/to/puregym-tracker.sh LOGIN_EMAIL LOGIN_PIN`. Make sure the correct full path is provided.  
Press `Esc`, then type `:wq` followed by pressing `Enter` to save the file.  
The job will run within the next 5 minutes.
