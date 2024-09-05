module "vertice_governance_role" {
  count  = var.governance_role_enabled ? 1 : 0
  source = "./modules/vertice-governance-role"

  report_bucket_names                    = [var.cur_bucket_name, var.cor_bucket_name]
  vertice_account_ids                    = var.vertice_account_ids
  account_type                           = var.account_type
  governance_role_external_id            = var.governance_role_external_id
  governance_role_assume_policy_json     = var.governance_role_assume_policy_json
  governance_role_additional_policy_json = var.governance_role_additional_policy_json
  billing_policy_addons                  = var.billing_policy_addons
}

module "vertice_cur_bucket" {
  count  = var.cur_bucket_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cur-bucket"

  cur_bucket_name            = var.cur_bucket_name
  cur_bucket_force_destroy   = var.cur_bucket_force_destroy
  cur_bucket_versioning      = var.cur_bucket_versioning
  cur_bucket_lifecycle_rules = var.cur_bucket_lifecycle_rules
}

module "vertice_cur_report" {
  count  = var.cur_report_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cur-report"

  cur_report_name        = var.cur_report_name
  cur_report_bucket_name = var.cur_bucket_name
  cur_report_s3_prefix   = var.cur_report_s3_prefix

  ## CUR report is currently available only in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  depends_on = [module.vertice_cur_bucket]
}

module "vertice_cor_report" {
  count  = var.cor_report_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cor-report"

  cor_report_name           = var.cor_report_name
  cor_report_bucket_name    = var.cor_bucket_name
  cor_report_s3_prefix      = var.cor_report_s3_prefix
  cor_columns_for_selection = var.cor_columns_for_selection
  cor_table_configurations  = var.cor_table_configurations

  ## CUR report is currently available only in the us-east-1 region
  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  depends_on = [module.vertice_cor_bucket]
}

module "vertice_cor_bucket" {
  count  = var.cor_bucket_enabled && (var.account_type == "billing" || var.account_type == "combined") ? 1 : 0
  source = "./modules/vertice-cor-bucket"

  cor_bucket_name            = var.cor_bucket_name
  cor_bucket_force_destroy   = var.cor_bucket_force_destroy
  cor_bucket_versioning      = var.cor_bucket_versioning
  cor_bucket_lifecycle_rules = var.cor_bucket_lifecycle_rules
}