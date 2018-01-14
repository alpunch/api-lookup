# api-lookup

This product deploys an API intented to lookup and check postal addresses validity.  

It relies on free data available at https://adresse.data.gouv.fr  


## Pre-flight check-list
  
You'll need :  
- Basic unix knowledge.  
- An AWS account with a valid subscription.  
  
## Credentials

From your root account, create a IAM user "terraform"
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html

Assign the "AmazonEC2FullAccess" policy to the user

or copy/paste this one :
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "cloudwatch:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot*",
      "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "spot.amazonaws.com"
          }
        }
     },
     {
       "Effect": "Allow",
       "Action": "iam:CreateServiceLinkedRole",
       "Resource": "arn:aws:iam::*:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2Spot*",
       "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "spotfleet.amazonaws.com"
          }
        }
     },
     {
       "Effect": "Allow",
       "Action": "iam:CreateServiceLinkedRole",
       "Resource": "arn:aws:iam::*:role/aws-service-role/ec2scheduled.amazonaws.com/AWSServiceRoleForEC2Scheduled*",
       "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "ec2scheduled.amazonaws.com"
          }
       }
    },
     {
       "Effect": "Allow",
       "Action": "iam:CreateServiceLinkedRole",
       "Resource": "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
       "Condition": {
          "StringLike": {
              "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
          }
       }
    }
  ]
}
```  


Get your AWS credentials  
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html  

Rename "secret.provider.auto.example" to "secret.provider.auto.tfvars"  
Open "secret.provider.auto.tfvars"  
Replace the example values with your correct credentials  

## Instalation

```
git clone https://github.com/Agadagluglu/api-lookup.git

cd api-lookup/terraform

terraform init  

terraform plan  

terraform apply  
```

Go to EC2 management console.  

Get the ip associated to "docker-node".  

## Test the API using Postman  

#### API documentation

The API support an unique endpoint "/search/"  
This endpoint accepts HTTP POST resquests only.  

Usage : sumbit a json body with the following parameters :  
- "q"   : query.        Must be the adress queried by the user. 
- "hn"  : house number. Must be an integer.    
- "st"  : street.       Must be a string.  
- "pc"  : postal code.  Must be an integer.  
- "ct"  : city.         Must be a string.  

Exemple : 
```
{"q": "11 impasse canart", "hn": "11", "st": "Impasse Canart", "pc": "75012", "ct": "Paris" }
```

#### Install postman  
https://www.getpostman.com/apps  

#### Open postman  

#### Clik on the "Import" button  

#### Select ```/path/to/api-lookup/postman/api-lookup doc.postman_collection```  

#### Modify the POST url (ex: http://54.154.161.206/search/) with "docker-node" public IP (from the EC2 console).  

#### Modify the body with an address to look up

Exemple : 
```
{"q": "11 impasse canart", "hn": "11", "st": "Impasse Canart", "pc": "75012", "ct": "Paris" }
```
  