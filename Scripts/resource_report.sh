
#!/usr/bin/env bash

terraform show -json | jq '
  [
    .values.root_module.resources? // [],
    (.values.root_module.child_modules? // [] | map(.resources?) | flatten)
  ]
  | flatten
  | map(
      if .type == "aws_instance" then
        {
          type: .type,
          name: .name,
          ami: .values.ami,
          instance_type: .values.instance_type,
          availability_zone: .values.availability_zone,
          tags: .values.tags
        }
      elif .type == "aws_s3_bucket" then
        {
          type: .type,
          name: .name,
          bucket: .values.bucket,
          acl: .values.acl,
          tags: .values.tags
        }
      elif .type == "aws_security_group" then
        {
          type: .type,
          name: .name,
          description: .values.description,
          vpc_id: .values.vpc_id,
          tags: .values.tags
        }
      elif .type == "aws_lambda_function" then
        {
          type: .type,
          name: .name,
          function_name: .values.function_name,
          runtime: .values.runtime,
          handler: .values.handler,
          timeout: .values.timeout,
          tags: .values.tags
        }
      elif .type == "aws_rds_instance" then
        {
          type: .type,
          name: .name,
          identifier: .values.identifier,
          engine: .values.engine,
          instance_class: .values.instance_class,
          multi_az: .values.multi_az,
          allocated_storage: .values.allocated_storage,
          tags: .values.tags
        }
      else
        {
          type: .type,
          name: .name
        }
      end
    )
'
