#!/bin/bash
sudo groupadd -f devteam
echo "attempting to create group  'devteam'"
if getent group devteam > /dev/null; then
	echo "Group for the users created successfully"
	echo "Do you want to create users with 'default' names (user1-user5) or 'custom' name?"
	read -p "Enter 'default' or 'custom':" user_choice

	if [["$user_choice" =~ ^[Dd]efault$]]; then
		for i in {1..5}; do
			username="user$i"
			sudo useradd -m -G devteam "$username"
			echo "$username:12345678pass" | sudo chpasswd
			sudo chage -d 0 "$username"
			echo "User '$username' has been created and their default passwords set to expire when logged into."
		done
		echo "All 5 users have been created with default usernames."

	elif [["$user_choice" =~ ^[Cc]ustom$]]]; then
		for i in {seq 1 5}; do
			read -p "Enter a name for user$i:" username
			sudo useradd -m -G devteam "$username"
			echo "$username:12345678pass" | sudo chpasswd
			sudo chage -d 0 "$username"
			echo "User '$username' has been created and their default passwords set to expire when logged into."
		done
		echo "All 5 users have been created with their custom names"
	else
		echo "Invalid choice. Please enter 'default' or 'custom'."
	
	fi
else
echo "Error: The group for the users was not created successfully."
fi

