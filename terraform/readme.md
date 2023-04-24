1. https://fabianlee.org/2021/07/05/kvm-installing-terraform-and-the-libvirt-provider-for-local-kvm-resources/
2. sudo apt install jq unzip git -y

# get latest version using github api
TERRA_VERSION=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r ".tag_name" | cut -c2-)

# pull latest release
wget -v4 https://releases.hashicorp.com/terraform/${TERRA_VERSION}/terraform_${TERRA_VERSION}_linux_amd64.zip

# unzip
unzip terraform_${TERRA_VERSION}_linux_amd64.zip

# set permissions and move into path
chmod +x terraform
sudo mv terraform /usr/local/bin/.

# validate
terraform version

# simple-test
1. cd terraform/simple-test
2. terraform init
3. terraform apply
4. terraform destroy

# checking for updates
1. wget https://github.com/taliesins/terraform-provider-hyperv/archive/refs/tags/v1.0.4.tar.gz && tar -xvf v1.0.4.tar.gz && v1.0.4.tar.gz

# policy requirements:
https://techcommunity.microsoft.com/t5/ask-the-performance-team/task-scheduler-error-8220-a-specified-logon-session-does-not/ba-p/375056