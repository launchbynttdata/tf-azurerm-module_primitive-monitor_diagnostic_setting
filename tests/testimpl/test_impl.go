package common

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	armmonitor "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestDiagnosticSetting(t *testing.T, ctx types.TestContext) {
	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	diagnosticSettingsClient, err := armmonitor.NewDiagnosticSettingsClient(credential, &options)
	if err != nil {
		t.Fatalf("Error creating diagnostic setting client: %v", err)
	}

	t.Run("doesDiagnosticSettingExist", func(t *testing.T) {
		diagnosticSettingName := terraform.Output(t, ctx.TerratestTerraformOptions(), "diagnostic_setting_name")
		diagnosticSettingId := terraform.Output(t, ctx.TerratestTerraformOptions(), "id")
		firewallId := terraform.Output(t, ctx.TerratestTerraformOptions(), "firewall_id")

		diagnosticSetting, err := diagnosticSettingsClient.Get(context.Background(), firewallId, diagnosticSettingName, nil)
		if err != nil {
			t.Fatalf("Error getting diagnostic setting: %v", err)
		}

		assert.Equal(t, strings.ToLower(diagnosticSettingId), strings.ToLower(*diagnosticSetting.ID), "Diagnostic Setting ID does not match.")
	})
}
