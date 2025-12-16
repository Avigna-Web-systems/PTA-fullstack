using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using PTA.Core.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton<IWeatherService, WeatherService>();

var app = builder.Build();

if (app.Environment.IsDevelopment()) 
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    // Optional: Gate Swagger behind dev-only for prod
    app.UseSwagger();
    app.UseSwaggerUI();
}

// NEW: Handle root path (/)
app.MapGet("/", () => Results.Ok(new 
{ 
    message = "Welcome to PTA Dev Frontend API!", 
    version = "1.0", 
    docs = "/swagger",
    sampleEndpoint = "/api/Weather"
}));

app.MapControllers();

app.Run();
