# aws-tools
AWS Tools

A number of scripts to help manage AWS services.

# Installation

Clone the repository to your server:

`sudo git clone https://github.com/bluora/aws-tools.git /usr/local/aws-tools`

Run the ./install.sh script to install packages and create symbolic links.

Configure AWS with a default profile that will restrict/provide access. Some scripts may not work because the profile as been limited.

`aws configure`

## Specific install for aws-update-route53

AWS Route53 Updater is a script that will update the record set for the instance in a specific domain zone. For example, we have an EC2 instance `i-55c5489c` that has a public IP. AWS changes an instance's public IP whenever it is stopped, so this script on bootup will update the record with the current public IP. eg i-55c5489c.aws.domainname.com A record 54.66.224.197

Manual commands for SystemD based versions (add it as a starting service)

`sudo cp  /usr/local/aws-tools/service/aws-update-route53.service /usr/lib/systemd/system/aws-update-route53.service`

For rc.local startup

`sudo echo "/usr/bin/aws-update-route53-public-ip" >> /etc/rc.local`

**AWS IAM configuration**

Configure AWS with a specific (restricted) profile for updating Route53 records.

In AWS IAM, add a new user (eg awsdns) with the following security profile:

(change domainname and domainzoneid to your details)

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetHostedZone",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::dominaname/domainzoneid"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

Add the profile to the AWS configuration

`aws configure --profile awsdns`

Update the Route53 configuration with your details

`/etc/aws-update-route53.cfg`

* PROFILE_NAME is the AWS profile that you used above.
* ZONE_ID is the Route53 ID for your zone
* DOMAIN is the FQDN that you will store your EC2 server name and public ip.

