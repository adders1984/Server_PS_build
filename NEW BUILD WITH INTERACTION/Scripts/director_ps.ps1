# CREATE DIRECTORIES

          # Get the CSV file path
          $csvFile = "C:\Users\Administrator\Documents\Directories.csv"

          # Read the CSV file into an array of objects
          $dirs = Import-Csv $csvFile

          # Loop through each directory in the array and create it with the specified permissions
          foreach ($dir in $dirs) {
            $path = $dir.Path
            $group = $dir.Group
            $rights = $dir.Rights

            # Create the directory if it doesn't exist
            if (-not (Test-Path $path)) {
              New-Item -ItemType Directory -Path $path | Out-Null
            }

            # Set the permissions on the directory
            $acl = Get-Acl $path
            $acl.SetAccessRuleProtection($true, $false)

            # Add the access rule to the ACL
            $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("$domain\$group", $rights, "ContainerInherit,ObjectInherit","None","Allow")
            $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit","None","Allow")
            $rule3 = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit","None","Allow")
            $rule4 = New-Object System.Security.AccessControl.FileSystemAccessRule("CREATOR OWNER", "FullControl", "ContainerInherit,ObjectInherit","None","Allow")
            $acl.SetAccessRule($rule1)
            $acl.SetAccessRule($rule2)
            $acl.SetAccessRule($rule3)
            $acl.SetAccessRule($rule4)
            Set-Acl $path $acl
          }
