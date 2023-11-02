# CREATE GROUPS

 $import_groups = Import-Csv -Path C:\Users\Administrator\Documents\groups.csv
          foreach ($group in $import_groups) {
          $name = $group.Group
          $category = $group.Category
          $scope = $group.Scope
          $path = $group.Org_Unit

          switch ($category) {
          "Security" {
            $groupType = "Security"
          }
          "Distribution" {
            $groupType = "Distribution"
          }
          default {
            Write-Warning "Invalid group category specified: $category"
            continue
          }
          }

          switch ($scope) {
          "Global" {
            $groupScope = "Global"
          }
          "DomainLocal" {
            $groupScope = "DomainLocal"
          }
          "Universal" {
            $groupScope = "Universal"
          }
          default {
            Write-Warning "Invalid group scope specified: $scope"
            continue
          }
          }

          New-ADGroup `
            -Name $name `
            -SamAccountName $name `
            -GroupCategory $groupType `
            -GroupScope $groupScope `
            -DisplayName $name `
            -Path $path
            }

          # Import the CSV file
          $groupData = Import-Csv -Path C:\Users\Administrator\Documents\groups.csv

          # Loop through each row in the CSV file
          foreach ($row in $groupData) {
            # Get the group name and members from the current row
            $groupName = $row.Group
            $members = $row.Members -split ","

          # Add each member to the group
          foreach ($member in $members) {
            Add-ADGroupMember -Identity $groupName -Members $members
          }
          }