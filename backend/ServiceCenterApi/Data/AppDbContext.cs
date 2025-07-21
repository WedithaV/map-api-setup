using Microsoft.EntityFrameworkCore;
using ServiceCenterApi.Models;

namespace ServiceCenterApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
        public DbSet<ServiceCenter> ServiceCenters { get; set; }
    }
}