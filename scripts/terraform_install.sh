# Update the package list and install required dependencies (gnupg, software-properties-common)
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Download HashiCorp GPG key and store it in /usr/share/keyrings/hashicorp-archive-keyring.gpg
wget -O- https://apt.releases.hashicorp.com/gpg | \
	        gpg --dearmor | \
		        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Display the fingerprint of the HashiCorp GPG key for verification
gpg --no-default-keyring \
	        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
		        --fingerprint

# Add the HashiCorp repository to the system's package sources
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
	        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
		        sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update the package list to include the HashiCorp repository
sudo apt update -y

# Install Terraform from the HashiCorp repository
sudo apt-get install terraform -y
