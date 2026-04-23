# g32_user_tool
a bash psql script to output to a set of html pages of regsitered d-star users, their registered terminal id and a second html page of system-wide html list of deleted registrations.

The script writes to output to 2 files to the /var/www/html directory. You may decide to put this in a "hidden" directory, your call.
  
Recommend putting the script file in the /dstar/scripts directory. Make it executable with: chmod +x

Use a cron job to execute it on a schedule.

If you want the html report "hidden", create a hidden directory like /var/www/html/.reports and change the script to write the 2 files there.