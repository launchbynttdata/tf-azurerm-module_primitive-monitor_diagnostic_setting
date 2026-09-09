# tf-azurerm-module_primitive-monitor_diagnostic_setting

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module helps set up azure monitor to collect data for log analytics workspace.

## Usage

This repository has example configurations in:

- [examples/app_insights](examples/app_insights)
- [examples/with_firewall](examples/with_firewall)
- [examples/with_storage_account](examples/with_storage_account)

## Module Development

Use this repository as a standard Launch Terraform primitive module.

- Keep examples and tests aligned with code changes because they are part of the public contract.
- Preserve generated files and automation patterns from the shared skeleton unless a module-specific exception is required.
- Prefer make targets and pre-commit hooks over ad hoc commands to match CI behavior.

## Pre-Requisites

The following commands should be available on your system:

- asdf or mise
- make
- python3 (for pre-commit)

Install pinned tool versions and bootstrap dependencies from the repository root:

```sh
make configure
```

For Azure-backed tests, set environment variables using:

```sh
make env
```

## Pre-Commit Hooks

This repository uses [.pre-commit-config.yaml](.pre-commit-config.yaml) to run Terraform, Go, and repository hygiene checks.

Install local hooks:

```sh
pre-commit install --hook-type commit-msg
```

Run all hooks manually:

```sh
pre-commit run --all-files
```

## Local Validation

Run the same validations used in CI:

```sh
make lint
make check
```

If a hook or generated file changes content (for example terraform-docs), commit the updates and rerun the checks.

## Review And Merge Process

- Open a pull request with a clear summary of functional and test-impacting changes.
- Resolve all review comments and ensure CI is green before merge.
- Keep commits focused and use conventional commit messages when possible.

## Automatic Updates

This repository receives periodic updates from the shared launch-terraform-skeleton baseline via Copier automation. Keep skeleton-managed files aligned with upstream expectations so automated updates continue to merge cleanly.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.77, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br/>    category_group = optional(string, null)<br/>    category       = optional(string, null)<br/>  }))</pre> | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. | `string` | `null` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | (Optional) List of metrics and its properties. | <pre>list(object({<br/>    category = string<br/>    enabled  = optional(bool)<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | (Optional) Specifies the ID of a Storage Account where Diagnostics Data should be sent. | `string` | `null` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Diagnostic Setting. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Diagnostic Setting. |
<!-- END_TF_DOCS -->
