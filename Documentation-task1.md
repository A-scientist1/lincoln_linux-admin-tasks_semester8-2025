Task 1 Doumentation:

Task instruction:

**User & Group Management Auttion**

Write a Bash script to create 5 new users, add them to a group
"devteam", set their passwords, and force them to change password on
first login.

Script logic:

A bash script that creates 5 users with the same default password for
each user, who are assigned either a default username (user1 to user5)
or a custom username based on user input. All users are added to a group
called devteam, and their passwords are set to expire upon first login.

Proposed commands to achieve the script logic:

i. **nano** -> a linux text editor to create and edit the script file

ii. shebang (**#!/bin/bash**) -> used at the beginning of the scriptto
indicate that the file is a script and should be interpreted by the Bash
shell.

iii. **sudo** -> gives administrative priviladges by running commands
as a root user, necessary for creating groups and users.

iv. **groupadd -f** -> creates a goup for users recieving the name for
the group as argument. The "-f" option or flag, known as "--force",
gracefully exit the command using a success code (0) when the group to
be created exists.

v. **echo** -> ouputs messages to the standard out of the terminal, it
can be used for user prompts and status messages.

vi. **getent group** -> "getent", called "get entries", queries
the system's database, to check if a given keyword exists. in this case,
it's querying the system's "group" database.

vii. **read -p** -> "read" captures user input from the terminal.
The "-p" option allows specifying a prompt message to display to the
user.

viii. **if ... then ... elif ... else ... fi** -> conditional
branching in bash that allows the execution of different actions
depending on user input or command results.

ix. **for i in {1..5}, or for i in $(seq 1 5)** -> a loop construct
(for loop), to iterate over a sequence of numbers automating repetitive
tasks like creating multiple users.

x. **useradd -m -G** -> Creates a new user account. The "-m" option
creates a home directory for the user, and the "-G" option adds the
user to an additional specified group (in this case, devteam).

xi. **chpasswd** -> Updates passwords for multiple users in batch or
non-interactive mode by reading a list of "username:password" pairs
from a file or from the output of another program via standard input
(using a pipe). It then updates the corresponding user accounts
accordingly.

xii. **chage -d 0** -> forces a user's password to expire
immediately, requiring the user to change their password upon first
login. The "-d 0" sets the last password change date to epoch time
(January 1, 1970), triggering expiration.

xiii. **[[... =~ ...]]** -> Tests if a string matches a
regular expression pattern, like allowing a case-insensitive string.

The script with each line explained:

--bash code starts---

```bash

#!/bin/bash

# Specifies that this script should be interpreted by the Bash shell.

sudo groupadd -f devteam

# Attempts to create a group named 'devteam' using the 'groupadd'command.

# The '-f' flag forces the command to exit successfully even if the group already exists.

echo "attempting to create group 'devteam'"

# Prints a message to the terminal indicating that the script is attempting to create the 'devteam' group.

if getent group devteam > /dev/null; then

# Checks if the 'devteam' group exists in the system by using the 'getent' command.

# The output is redirected to /dev/null to suppress it, and the condition evaluates to true if the group exists.

echo "Group for the users created successfully"

# Prints a confirmation message if the 'devteam' group was found (i.e., created successfully or already existed).

echo "Do you want to create users with 'default' names (user1-user5) or 'custom' name?"

# Prompts the user to choose between creating users with default names (user1 to user5) or custom names.

read -p "Enter 'default' or 'custom':" user_choice

# Reads the user's input into the variable 'user_choice'.

# The '-p' flag displays the prompt message before capturing input.

if [[ "$user_choice" =~ ^[Dd]efault$ ]]; then

# Checks if the user's input matches 'default' or 'Default' (case-insensitive) using a regular expression.

for i in {1..5}; do

# Starts a loop to iterate 5 times (for creating 5 users), with 'i' taking values from 1 to 5.

username="user$i"

# Creates a username by concatenating "user" with the loop index (e.g., user1, user2, etc.).

sudo useradd -m -G devteam "$username"

# Creates a new user with the specified username.

# '-m' creates a home directory for the user.

# '-G devteam' adds the user to the 'devteam' group.

echo "$username:12345678pass" | sudo chpasswd

# Sets the user's password to '12345678pass' by piping the username and password to the 'chpasswd' command.

sudo chage -d 0 "$username"

# Forces the user to change their password on first login by setting the last password change date to 0.

echo "User '$username' has been created and their default passwords set to expire when logged into."

# Prints a confirmation message that the user was created and their password is set to expire on login.

done

# Ends the loop for creating default-named users.

echo "All 5 users have been created with default usernames."

# Prints a message indicating that all 5 users with default names have been created.

elif [[ "$user_choice" =~ ^[Cc]ustom$ ]]; then

# Checks if the user's input matches 'custom' or 'Custom' (case-insensitive) using a regular expression.

for i in $(seq 1 5); do

# Starts a loop to iterate 5 times (for creating 5 users), using the 'seq' command to generate numbers 1 to 5.

read -p "Enter a name for user$i:" username

# Prompts the user to enter a custom username for the current iteration (e.g., "Enter a name for user1:").

sudo useradd -m -G devteam "$username"

# Creates a new user with the custom username provided by the user.

# '-m' creates a home directory, and '-G devteam' adds the user to the 'devteam' group.

echo "$username:12345678pass" | sudo chpasswd

# Sets the user's password to '12345678pass' using the 'chpasswd' command.

sudo chage -d 0 "$username"

# Forces the user to change their password on first login by setting the last password change date to 0.

echo "User '$username' has been created and their default passwords set to expire when logged into."

# Prints a confirmation message that the custom-named user was created and their password is set to expire.

done

# Ends the loop for creating custom-named users.

echo "All 5 users have been created with their custom names"

# Prints a message indicating that all 5 users with custom names have been created.

else

echo "Invalid choice. Please enter 'default' or 'custom'."

# Prints an error message if the user enters anything other than 'default' or 'custom' (case-insensitive).

fi

# Ends the if-elif-else block for handling the user's choice.

else

echo "Error: The group for the users was not created successfully."

# Prints an error message if the 'devteam' group could not be found (i.e., group creation failed).

fi

# Ends the if-else block for checking the existence of the 'devteam' group.

```

--bash code ends---

Execution:

Run the script by typing in its relative path
and pressing the return/enter key.

Verification:

Run the command: "cut -d: -f1 /etc/passwd", or "getent passwd | cut
-d: -f1", and check the lower pat of the output to check if the users
have been created.

The "cut" command is used to extract sections from each line of a file
with a specified delimeter (in this case ":")

The "/etc/passwd" is a common file that contains user account
information, with fields separated by a colon (:)

The "-d" option allows the "cut" command to recieve delimeters that
specifies how sections (in this case, fields) are separated. Without
providing a delimiter (e.g., -d:), the "cut" command will fail or
produce unexpected results.

"-f1" selects the first field (the username) from each line within a
file (the "passwd" file. E.g.,
username:password:UID:GID:GECOS:home_directory:shell).

In a nutshell, the shell command "cut -d: -f1 /etc/passwd" lists all
usernames on a Linux system by extracting the first field from each line
of the /etc/passwd file.

