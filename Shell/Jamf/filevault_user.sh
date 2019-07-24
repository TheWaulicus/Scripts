### Find the logged in usernam
loggedInUser=$(stat -f%Su /dev/console)

### Enable the user for FileVault 2
sudo fdesetup add -usertoadd $loggedInUser