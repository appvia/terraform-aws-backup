resource "aws_cloudformation_stack_set" "role" {
  name        = format("%s-role", var.name)
  description = format("Provisions IAM roles for AWS Backup")

  template_body = local.cf_role_tpl

  parameters = {
    RoleName = "backup-test"
    RolePath = "/backup/"
  }

  permission_model = "SERVICE_MANAGED"

  capabilities = [
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND",
    "CAPABILITY_IAM",
  ]

  tags = merge(var.tags, {
    Name = var.name
  })

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  operation_preferences {
    failure_tolerance_count   = 0
    max_concurrent_percentage = 100
    region_concurrency_type   = "PARALLEL"
  }

  lifecycle {
    ignore_changes = [
      administration_role_arn,
    ]
  }
}

resource "aws_cloudformation_stack_set_instance" "role" {
  for_each = toset(local.backup_regions)

  stack_set_name = aws_cloudformation_stack_set.role.name
  region         = each.value

  deployment_targets {
    organizational_unit_ids = [
      "ou-66bv-dp4n113i",
    ]
  }
}
