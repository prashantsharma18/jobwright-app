using System.Reflection;
using ArchUnitNET.Loader;
using ArchUnitNET.xUnitV3;
using static ArchUnitNET.Fluent.ArchRuleDefinition;

namespace Jobwright.ArchitectureTests;

// ADR 0001: a module references only Jobwright.SharedKernel and other modules' *.Contracts.
public class ModuleBoundaryTests
{
    private const string ModulePrefix = "Jobwright.Modules.";

    // Increment 1's modules (ADR 0001). The rule must never pass because one of them was not loaded (plan C11).
    private static readonly string[] IncrementOneModules =
    [
        "Jobwright.Modules.Identity",
        "Jobwright.Modules.Identity.Contracts",
        "Jobwright.Modules.Tenancy",
        "Jobwright.Modules.Tenancy.Contracts",
    ];

    // Every Jobwright assembly this project references, copied next to the tests by the build.
    private static readonly Assembly[] JobwrightAssemblies = Directory
        .GetFiles(AppContext.BaseDirectory, "Jobwright.*.dll")
        .Select(path => Assembly.Load(AssemblyName.GetAssemblyName(path)))
        .Where(assembly => assembly != typeof(ModuleBoundaryTests).Assembly)
        .ToArray();

    [Fact]
    public void Modules_reference_only_SharedKernel_and_Contracts()
    {
        var loadedNames = JobwrightAssemblies.Select(assembly => assembly.GetName().Name).ToArray();
        Assert.All(IncrementOneModules, module => Assert.Contains(module, loadedNames));

        var architecture = new ArchLoader().LoadAssemblies(JobwrightAssemblies).Build();

        foreach (var module in JobwrightAssemblies.Where(assembly => NameOf(assembly).StartsWith(ModulePrefix, StringComparison.Ordinal)))
        {
            var forbidden = JobwrightAssemblies.Where(other => other != module && !IsAllowedTarget(other)).ToArray();

            // Increment 1's modules hold no types until part 3, and ArchUnitNET by default refuses a rule that matches
            // no type. The assertion above, that every module was loaded, is this test's guard against a vacuous pass.
            Types().That().ResideInAssembly(module).Should()
                .NotDependOnAny(Types().That().ResideInAssembly(forbidden[0], forbidden[1..]))
                .Because("a module references only Jobwright.SharedKernel and other modules' *.Contracts (ADR 0001)")
                .WithoutRequiringPositiveResults()
                .Check(architecture);
        }
    }

    private static bool IsAllowedTarget(Assembly assembly) =>
        NameOf(assembly) == "Jobwright.SharedKernel" || NameOf(assembly).EndsWith(".Contracts", StringComparison.Ordinal);

    private static string NameOf(Assembly assembly) => assembly.GetName().Name ?? string.Empty;
}
