## Destroy will DELETE the snapshots here

# Creates single snapshot, once
resource "aws_ebs_snapshot" "a_single_snapshot" {
  volume_id = aws_ebs_volume.attached_volume_a.id

  tags = {
    Name = "attached_volume_a_snap"
  }
}

#would copy to the provider region even if different from source region
resource "aws_ebs_snapshot_copy" "a_single_snapshot_copy" {
  source_snapshot_id = aws_ebs_snapshot.a_single_snapshot.id
  source_region      = aws_ebs_snapshot.a_single_snapshot.region

  tags = {
    Name = "attached_volume_a_snap_copy"
  }
}

## Recycle bin retention rules
resource "aws_rbin_rule" "tag_level_rbin_rule" {
  description   = "Tag-level retention rule"
  resource_type = "EBS_SNAPSHOT"

  resource_tags {
    resource_tag_key   = "ManagedBy"
    resource_tag_value = "Terraform"
  }

  retention_period {
    retention_period_value = 2
    retention_period_unit  = "DAYS"
  }
}

resource "aws_rbin_rule" "region_level_rbin_rule" {
  description   = "Region-level retention rule with exclusion tags"
  resource_type = "EC2_IMAGE"

  exclude_resource_tags {
    resource_tag_key   = "other_tag_name"
    resource_tag_value = "other_tag_value"
  }

  retention_period {
    retention_period_value = 5
    retention_period_unit  = "DAYS"
  }
}

## Auto backup and retention
/* resource "aws_dlm_lifecycle_policy" "lifecycle_policy" {
  description        = "Set auto daily volumes snapshot"
  execution_role_arn = data.aws_iam_role.data_lifecycle_full_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    target_tags = {
      ManagedBy = "Terraform"
    }

    schedule {
      name      = "DailySnapshots"
      copy_tags = true

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 7
      }
    }
  }
} */
