# aws-tools
AWS Tools

A number of scripts to help manage AWS services.

# Installation

Clone to to /usr/local/aws-tools
`sudo git clone https://github.com/bluora/aws-tools.git /usr/local/aws-tools`

Run the ./install.sh script to setup and install packages, create symbolic links and add the service (for SystemD based distributions)

Configure AWS with a default profile.
`aws configure`

Configure AWS with a specific (restricted) profile for updating Route53 records.

In AWS IAM, add a new user (eg awsdns) with the following security profile:

(change domainname and domainzoneid to your details)

``
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
``

eg `aws configure --profile awsdns`
