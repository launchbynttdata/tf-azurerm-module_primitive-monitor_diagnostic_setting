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

	diagnosticSettingName := terraform.Output(t, ctx.TerratestTerraformOptions(), "diagnostic_setting_name")
	diagnosticSettingId := terraform.Output(t, ctx.TerratestTerraformOptions(), "id")

	t.Run("doesDiagnosticSettingExistWithFirewall", func(t *testing.T) {
		ctx.EnabledOnlyForTests(t, "with_firewall")
		firewallId := terraform.Output(t, ctx.TerratestTerraformOptions(), "firewall_id")

		diagnosticSetting, err := diagnosticSettingsClient.Get(context.Background(), firewallId, diagnosticSettingName, nil)
		if err != nil {
			t.Fatalf("Error getting diagnostic setting: %v", err)
		}

		assert.Equal(t, strings.ToLower(diagnosticSettingId), strings.ToLower(*diagnosticSetting.ID), "Diagnostic Setting ID does not match.")
	})

	t.Run("doesDiagnosticSettingExistWithAppInsights", func(t *testing.T) {
		ctx.EnabledOnlyForTests(t, "app_insights")
		appInsightsId := terraform.Output(t, ctx.TerratestTerraformOptions(), "app_insights_id")

		diagnosticSetting, err := diagnosticSettingsClient.Get(context.Background(), appInsightsId, diagnosticSettingName, nil)
		if err != nil {
			t.Fatalf("Error getting diagnostic setting: %v", err)
		}

		/* The diagnostic setting ID returned from the terraform provider is in a different format than the one returned from the Azure SDK.

		The terraform provider returns the ID in the format:
		/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{appInsightsName}|{diagnosticSettingName}
		While the Azure SDK returns the ID in the format:
		/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{appInsightsName}/providers/microsoft.insights/diagnosticSettings/{diagnosticSettingName}

		To compare the two IDs, we need to convert the terraform provider ID to the Azure SDK ID format.  If either of these sources changes the format of the ID,
		this test will need to be updated.
		*/

		convertedId := strings.ReplaceAll(diagnosticSettingId, "|", "/providers/microsoft.insights/diagnosticSettings/")

		assert.Equal(t, strings.ToLower(convertedId), strings.ToLower(*diagnosticSetting.ID), "Diagnostic Setting ID does not match. Unconverted ID: %s", diagnosticSettingId)
	})
}
