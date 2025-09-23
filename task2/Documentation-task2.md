Task 2 Doumentation:
Task instruction:
**File Permissions & ACLs Project**
Create a shared directory `/shared_data` where group members can read/write but not
delete others' files. Use ACL to grant read-only access to one extra user outside the group.

**Solution:**

**Instruction explanation**: 
We'll create a directory named shared_data in this Git repo (Owned by the user "ubuntu").
Using the classic POSIX discretionary access control (DAC) ownership model, we’ll assign one group as the primary group to have access to the directory. Then, using POSIX ACLs (Access Control Lists), we’ll grant access to two additional groups.
A sticky bit will be assigned to the directory, making sure that an item (file, or sub-directory) within the directory can only be deleted by its owner.
Lastly, a specific user will be given a read-only permission to this directory using POSIX ACLs (Access Control Lists).

**Proposed commands to achieve the task:**
1. **mkdir** -> "mkdir /path/to/directory", creates a new directory at the specified path.

2. **chown/chgrp** -> "sudo chown :group /path/to/directory", or "chgrp <new_group> /path/to/directory", changes the ownership of a file or directory.

3. **chmod** -> "chmod permissions /path/to/file_or_directory", changes standard file permissions.
Useful flags/permissions:
**r** = read
**w** = write
**x** = execute (needed for directory access)
**+t** = sticky bit (prevents users from deleting files owned by others in the directory).

4. **getfacl** -> "getfacl /path/to/file_or_directory", displays ACL permissions for a file or directory, showing which users/groups have specific access rights.

5. **setfacl** -> "setfacl -m u:username:permissions /path/to/file_or_directory", modifies ACL to grant specific permissions to a user.
Useful flags:
**-m** = modify ACL entry
**-x** = remove ACL entry
**-b** = remove all ACL entries
**-R** = apply recursively to all files/subdirectories
Permissions:
**r** = read
**w** = write
**x** = execute 
**u** = user
**g** = group

6. **ls -ld** -> "ls -ld /path/to/directory", lists directory permissions in detail.

7. **su / sudo** -> "su username", "sudo command"
**su** → switch to another user (useful for testing permissions).
**sudo** → run a command with superuser privileges.

**Flow of Command Execution to Achieve Task:**

```bash
# Step 1: Create the directory
mkdir shared_data
# Step 2: Assign group ownership
sudo chgrp shared_data
# Step 3: Based on the name of the directory and how the question goes, the folder would be a one that would contain data that is shared by a specific group of user and any other permitted user outside the group, so restrict base permissions (full access for owner & group only)
chmod 770 shared_data
# Step 4: Set sticky bit to prevent cross-user deletions
chmod +t shared_data
# Step 5: Install ACL
# ACL is not installed by default. Update and install ACL from apt (Advance Package Tool)
sudo apt update
sudo apt install acl
# Step 6: Assign ACLs
# Grant read-only access to external user
setfacl -m u:student1:r-x shared_data
# (Optional) Grant additional access to extra groups
setfacl -m g:worldlight:rwx shared_data
setfacl -m g:ubuntu:rwx shared_data
# Step 7: Verify ACLs
getfacl shared_data
# Step 8: Verify permissions and sticky bit
ls -ld shared_data
# Step 9: Test by switching users
su worldlight # should be able to create/write but not delete others' files
su student1   # should only be able to read
```
