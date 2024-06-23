resource "aws_organizations_policy" "backup" {
  name = var.name
  type = "BACKUP_POLICY"

  content = jsonencode({
    plans = local.backup_plans
  })
}

resource "aws_organizations_policy_attachment" "backup" {
  for_each = toset(var.deployment_targets)

  policy_id = aws_organizations_policy.backup.id
  target_id = each.value

  depends_on = [
    aws_cloudformation_stack_set_instance.role,
    aws_cloudformation_stack_set_instance.vault,
  ]
}
