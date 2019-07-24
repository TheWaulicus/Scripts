 #!/bin/sh

### This script prompts the user for their email address and then fills that in to the JSS
### This process will do a lookup against the LDAP server and fill the user info in the JSS

osascript -e 'tell application "System Events" to set visible of process "Self Service" to false'

username=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
  activate
  set input to display dialog "Enter You Email Address: " default answer "" buttons {"OK"} default button 1
  return text returned of input as string
end tell
__EOF__
)

jamf recon -endUsername $username

exit
