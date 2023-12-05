using Ipet.Data.Context;
using Microsoft.EntityFrameworkCore;
using Ipet.API.Configuration;
using Ipet.APIConfiguration;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using Microsoft.AspNetCore.Builder;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration
    .SetBasePath(builder.Environment.ContentRootPath)
    .AddJsonFile("appsettings.json", true, true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", true, true)
    .AddEnvironmentVariables();

builder.Services.AddDbContext<MeuDbContext>(options =>
{
    var connectionString = "server=164.152.244.159;database=ipet_mobile;uid=isaac;pwd=Isaacroque0209@;";

    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString))
           .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
});


builder.Services.ResolveDependencies();
builder.Services.AddIdentityConfig(builder.Configuration);
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
builder.Services.AddApiConfig();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseApiConfig(app.Environment);
app.UseHttpsRedirection();

app.UseAuthorization();

app.Run();
