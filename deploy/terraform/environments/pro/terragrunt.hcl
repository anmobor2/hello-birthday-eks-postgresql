include {
  path = find_in_parent_folders()  # Inheritance from the base
}
inputs = {
  environment = "pro"  #Passes vars to Terraform
}
# Override bucket via env var en CI: export TFSTATE_BUCKET=hello-birthday-tfstate-pro