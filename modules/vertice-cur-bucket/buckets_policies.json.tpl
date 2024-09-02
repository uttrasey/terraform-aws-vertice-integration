{
  "vertice_cur_bucket":{
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"denyInsecureTransport",
        "Effect":"Deny",
        "Principal":"*",
        "Action":"s3:*",
        "Resource":[
          "arn:aws:s3:::${cur_bucket_name}/*",
          "arn:aws:s3:::${cur_bucket_name}"
        ],
        "Condition":{
          "Bool":{
            "aws:SecureTransport":"false"
          }
        }
      },
      {
        "Sid":"AllowSSLRequestsOnly",
        "Effect":"Deny",
        "Principal":"*",
        "Action":"s3:*",
        "Resource":[
          "arn:aws:s3:::${cur_bucket_name}/*",
          "arn:aws:s3:::${cur_bucket_name}"
        ],
        "Condition":{
          "Bool":{
            "aws:SecureTransport":"false"
          }
        }
      },
      {
        "Sid":"AllowCURBucketActions",
        "Effect":"Allow",
        "Principal":{
          "Service":"billingreports.amazonaws.com"
        },
        "Action":[
          "s3:GetBucketPolicy",
          "s3:GetBucketAcl"
        ],
        "Resource":"arn:aws:s3:::${cur_bucket_name}",
        "Condition":{
          "StringEquals":{
            "aws:SourceAccount":"${account_id}",
            "aws:SourceArn":"arn:aws:cur:us-east-1:${account_id}:definition/*"
          }
        }
      },
      {
        "Sid":"AllowCURBucketObjectActions",
        "Effect":"Allow",
        "Principal":{
          "Service":"billingreports.amazonaws.com"
        },
        "Action":"s3:PutObject",
        "Resource":"arn:aws:s3:::${cur_bucket_name}/*",
        "Condition":{
          "StringEquals":{
            "aws:SourceAccount":"${account_id}",
            "aws:SourceArn":"arn:aws:cur:us-east-1:${account_id}:definition/*"
          }
        }
      }
    ]
  },
  "vertice_cor_bucket":{
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"EnableAWSDataExportsToWriteToS3AndCheckPolicy",
        "Effect":"Allow",
        "Principal":{
          "Service":[
            "billingreports.amazonaws.com",
            "bcm-data-exports.amazonaws.com"
          ]
        },
        "Action":[
          "s3:PutObject",
          "s3:GetBucketPolicy"
        ],
        "Resource":[
          "arn:aws:s3:::${cor_bucket_name}",
          "arn:aws:s3:::${cor_bucket_name}/*"
        ],
        "Condition":{
          "StringLike":{
            "aws:SourceArn":[
              "arn:aws:cur:us-east-1:${account_id}:definition/*",
              "arn:aws:bcm-data-exports:us-east-1:${account_id}:export/*"
            ],
            "aws:SourceAccount":"${account_id}"
          }
        }
      }
    ]
  }
}