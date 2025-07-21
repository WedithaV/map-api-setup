using Microsoft.EntityFrameworkCore;
using ServiceCenterApi.Data;

var builder = WebApplication.CreateBuilder(args);

// Force binding to all network interfaces
builder.WebHost.UseUrls("http://0.0.0.0:5152", "https://0.0.0.0:7023");

builder.Services.AddControllers();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();

    // Disable HTTPS redirection in development to avoid SSL cert issues with self-signed certs
    // app.UseHttpsRedirection();  // <-- Commented out in development
}
else
{
    // Enable HTTPS redirection in production environment
    app.UseHttpsRedirection();
}

app.UseCors("AllowAll");
app.UseAuthorization();
app.MapControllers();

app.Run();
