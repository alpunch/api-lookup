# api-lookup

This product deploys an API intented to lookup and check postal addresses validity.  

It relies on free data available at https://adresse.data.gouv.fr  


## Pre-flight check-list
  
You'll need :  
- An AWS account with a valide subscription.  
- Optionaly, a domain configured with Route53 or CloudFlare.  
  
## Credentials

Lookup AWS credentials.
Rename "secret.provider.auto.example" to "secret.provider.auto.tfvars".  
Open "secret.provider.auto.tfvars".  
Replace the example values with your correct credentials.  

Lookup Cloudflare credentials.  
Open "secret.provider.auto.tfvars".  
Replace the example values with your correct credentials.  

## Usage

terraform init  

terraform plan  

terraform apply  