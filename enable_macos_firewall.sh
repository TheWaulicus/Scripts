GLOBAL_STATE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)
BUILT_IN=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | grep "Automatically allow signed built-in software ENABLED")
BLOCK_ALL_INC=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall)

if [ "$GLOBAL_STATE" == "Firewall is enabled. (State = 2) " ]; then
  echo "STATE1"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Firewall ENABLED, Block Incoming connections ENABLED.. no action taken"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): $GLOBAL_STATE"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): $BLOCK_ALL_INC"
  exit 0
# IF Firewall is ENABLED, Automatically allow signed built-in software is ENABLED.. do nothing
# -n (not null)
elif [ "$GLOBAL_STATE" == "Firewall is enabled. (State = 1) " ] && [ -n "$BUILT_IN" ]; then
  echo "STATE2"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Firewall ENABLED, Block Incoming connections DISABLED, Allow BUILT-IN apps ENABLED.. no action taken"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): $GLOBAL_STATE"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): $BUILT_IN"
  exit 0
# IF Firewall is ENABLED, Automatically allow signed built-in software is DISABLED.. enable latter
elif [ "$GLOBAL_STATE" == "Firewall is enabled. (State = 1) " ] && [ "$BUILT_IN" == "" ]; then
  echo "STATE3"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Firewall ENABLED, Allow BUILT-IN signed apps to receive incoming connections DISABLED." 
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Enabling Allow BUILT-IN signed apps to receive incoming connections.." 
  /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on
  exit 0
  # IF Firewall is DISABLED.. turn on, allow BUILT-IN signed apps..
elif [ "$GLOBAL_STATE" == "Firewall is disabled. (State = 0)" ]; then
  echo "STATE4"
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Firewall DISABLED, Enabling macOS Firewall..."
  /usr/bin/defaults write /Library/Preferences/com.apple.sharing.firewall state -bool YES
  /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  echo "$(date "+%Y-%m-%d %H:%M:%S"): Enabling Allow BUILT-IN signed apps to receive incoming connections" 
  /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on
  exit 0
