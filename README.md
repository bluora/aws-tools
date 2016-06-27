# aws-tools
AWS Tools

A collection of scripts to help manage AWS services:-

* Get Instance Private IP using a tag name
 * `aws-get-instances TagName`
 * eg  `aws-get-instances "*-web-*"`
 * Returns array of private IP's
* Run a remote command on instances
 * `aws-run-remote-command TagName Command PemFile` 
 * eg  `aws-run-remote-command "*-web-*" "service httpd reload" "/root/.ssh/aws.pem"`
* Update Route53 A Record for the current instance
 * `aws-update-route53-public-ip`

# Installation

Clone the repository to your server:

`sudo git clone https://github.com/bluora/aws-tools.git /usr/local/aws-tools && /usr/local/aws-tools/install.sh`

Run the ./install.sh script to install packages and create symbolic links.

Configure AWS with a default profile that will restrict/provide access. Some scripts may not work because the profile has been limited.

## AWS IAM configuration

You will need to add a user (eg awsdns) and apply a limited access policy. 

** Access Key ID **
Found on the Security Credentials tab when viewing the user.

** AWS Secret Access Key **
Use the secret access key found when this user was created.

** Policy  **
You will need add your hostedzone ID into the placeholder <<<HOSTEDZONEID>>>.

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
        "arn:aws:route53:::hostedzone/<<<HOSTEDZONEID>>>"
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

```
# aws configure --profile awsdns

AWS Access Key ID [None]: <<<Access Key ID>>>
AWS Secret Access Key [None]: <<<Secret Access Key>>>
Default region name [None]: (leave empty)
Default output format [None]:  (leave empty)

```

## Specific install for aws-update-route53

AWS Route53 Updater is a script that will update the record set for the instance in a specific domain zone. For example, we have an EC2 instance `i-55c5489c` that has a public IP. AWS changes an instance's public IP whenever it is stopped, so this script on bootup will update the record with the current public IP. eg i-55c5489c.aws.example.com A record 54.66.224.197

### Update the Route53 configuration with your details

```
# sudo vi /etc/aws-update-route53.cfg

#!/bin/sh

AWS_ROUTE53_PROFILE_NAME="<<<PROFILENAME>>>"
AWS_ROUTE53_ZONE_ID="<<<HOSTEDZONEID>>>"
AWS_ROUTE53_DOMAIN="<<<DOMAINNAME>>>"
```

PROFILENAME is the AWS profile that you used above (eg awsnds)
HOSTEDZONEID is the Route53 ID for your zone
DOMAINNAME is the FQDN (eg aws.example.com.) that you will store your EC2 server name and public ip.

### SYSTEMD

** CentOS 7 **
Manual commands for SystemD based versions (add it as a starting service)

```
sudo cp  /usr/local/aws-tools/service/aws-update-route53.service /usr/lib/systemd/system/aws-update-route53.service
```

### RC.LOCAL
For rc.local startup

** Redhat / CentOS 6 **
```
sudo echo "/usr/bin/aws-update-route53-public-ip" >> /etc/rc.local
```

** Debian / Ubuntu **
```
# sudo vi /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#

# Update the IP for this instance
/usr/bin/aws-update-route53-public-ip
exit 0
```

