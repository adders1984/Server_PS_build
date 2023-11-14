# create a new storage pool
          New-StoragePool -FriendlyName JOKSS_POOL_1 -StorageSubSystemUniqueId (Get-StorageSubSystem).UniqueId -PhysicalDisks (Get-PhysicalDisk -CanPool $true)

          # create virtual disk
          New-VirtualDisk -FriendlyName JOKSS_VD_1 -StoragePoolFriendlyName JOKSS_POOL_1 -Size 10GB -ProvisioningType Thin -ResiliencySettingName Parity

          # initialize underlying physical disks
          Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName JOKSS_VD_1)

          # partition and format volumes from virtual disk
          $vd = Get-VirtualDisk -FriendlyName JOKSS_VD_1 | Get-Disk

          # bring the disk online
          Get-VirtualDisk -FriendlyName JOKSS_VD_1 | Get-Disk | Set-Disk -IsOffline $false

          $vd | 
            New-Partition -Size 2GB -Driveletter P | 
              Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "USER_DATA"

          $vd |     
            New-Partition -Size 1GB -Driveletter K | 
              Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "DEPARTMENT_DATA"
