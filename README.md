# CloudAutomation

How to Roll Out the Solution
To rollout the solution first download all files or clone GitHub repository (https://github.com/Grawikos/CloudAutomation.git). AWS CLI has to be installed and set up with default region and credentials. In the folder with all files execute 

Windows	MacOS/Linux
create.ps1 [-userid “<account user id>”, -bucketname “<name>”] 	deploy.sh [-userid “<account user id>”, -bucketname “<name>”]

<account user id> - optional, in not provided, found by command
<name> – optional, name used to create a bucket. It will be concatenated with userid to decrease chance of name collision, if not provided “athena-data-bucket”

After all stacks are created, the link to the website will be outputed to the terminal.

To deploy static website on the S3 Bucket go to folder with bucketscript.ps1 and website.json and execute

Windows	MacOS/Linux
bucketscript.ps1 [-userid “<account user id>”, -bucketname “<name>”, region “<region>”] 	bucketscript.sh [-userid “<account user id>”, -bucketname “<name>” , region “<region>”]

<region> - region of the user, if not provided, us-east-1

The link to the website will be outputed to the terminal

To connect to the ElasticStack and see logs of the application as admin, execute
Windows	MacOS/Linux
connect_admins.ps1 [-port “<local Port Number>”]	connect_admins.sh [-port “<local Port Number>”]

<local Port Number> - any open port on the host, if not provided – 8080.

The link to the website will be outputed to the terminal
