1. Transfer the required CSV files into the csv_files directory, 
check the files for any """ that can occur when converting from excel, this normally occurs in columns that contain multiple values
for eg:

LG_RELIEFB_SUPPLY_READ,domainlocal,security,"OU=RESOURCES,DC=JOKSS,DC=reliefB,DC=navy,DC=mil,DC=uk",no,"GG_STORES_ASST,GG_STORES_OFFICERS"

LG_RELIEFB_SUPPLY_READ,domainlocal,security,"OU=RESOURCES,DC=JOKSS,DC=reliefB,DC=navy,DC=mil,DC=uk",no,"""GG_STORES_ASST,GG_STORES_OFFICERS"""

*Also check for spaces for eg:

LG_RELIEFB_SUPPLY_READ

LG_ RELIEFB_SUPPLY_READ

2. Copy the ServerBuilder folder to the destination server Documents folder

3. From the destination servers documents folder right click on the Server_Builder.ps1 and run with powershell

4. If powershell launches in a small window, click in the top left of the window - properties - font and change the size

5. The tasks within the builder will change to green once completed, this is acheived through a text file that will be created in the
   scripts folder. When running DCPROMO if you miss the interaction to restart the server will restart itself but it will not create
   a text file called Completed_5 and DCPROMO will still appear white. 

description:
This server builder is intended to be used for single server builds and all that is required is the creation of the csv files. The builder works 
by asking the user to enter key information. This information is stored in an xml file called vars from then on if a script requires any of this
information it can be loaded in from the vars.xml. Throughout the server builder there are some interactions required and these are:

1. Enter Key Information
2. Storage pools (2K12 Onwards) confirmation Y x2
3. Default domain policy - Msg and title
4. GPO Control Panel - Enter GPO links from numbered list of OU,s
5. DHCP - Enter pool information
9. RDS NLA yes or no

