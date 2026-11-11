using System.Net;
using Microsoft.AspNetCore.Mvc.Testing;

namespace Jobwright.Api.Tests;

// K2: the API answers /health/live (draft contract: GET, no authentication, 200, no dependency checks).
[Trait("Category", "Unit")]
public class HealthLiveTests(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task HealthLive_answers_200_without_authentication()
    {
        // No credentials of any kind, and no redirect followed: a 302 to a sign-in or HTTPS URL must fail.
        using var client = factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });

        using var response = await client.GetAsync("/health/live", TestContext.Current.CancellationToken);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
