1. https://github.com/taliesins/terraform-provider-hyperv
2. https://github.com/taliesins/terraform-provider-hyperv#setting-up-server-for-provider-usage
3. cd terraform/terraform-provider-hyperv/
4. wget https://codeload.github.com/taliesins/terraform-provider-hyperv/zip/refs/heads/master && unzip master && rm master
4. wget https://github.com/taliesins/terraform-provider-hyperv/archive/refs/tags/v1.0.4.tar.gz && tar -xvf v1.0.4.tar.gz && rm v1.0.4.tar.gz
5. cd terraform-provider-hyperv-master
6. make
7. go mod download
8. go build
9. mkdir -p ~/.terraform.d/plugins/local/taliesins/hyperv/1.0.4/linux_amd64/
9. cp terraform-provider-hyperv ~/.terraform.d/plugins/local/taliesins/hyperv/1.0.4/linux_amd64/
10. cd ~/dataStore/terraform/hyperv-test
11. export TF_LOG="TRACE" && export WINRMCP_DEBUG="TRUE"
12. terraform init
13. terraform plan -out=tfplan
14. terraform apply tfplan
15. terraform init && terraform plan -out=tfplan && clear && terraform apply tfplan