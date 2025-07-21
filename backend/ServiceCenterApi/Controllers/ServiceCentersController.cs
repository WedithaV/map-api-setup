using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ServiceCenterApi.Data;
using ServiceCenterApi.Models;

namespace ServiceCenterApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ServiceCentersController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ServiceCentersController(AppDbContext context)
        {
            _context = context;
        }

        // POST: api/servicecenters
        [HttpPost]
        public async Task<ActionResult<ServiceCenter>> CreateServiceCenter(ServiceCenter serviceCenter)
        {
            if (string.IsNullOrEmpty(serviceCenter.Name))
            {
                return BadRequest("Name is required.");
            }

            _context.ServiceCenters.Add(serviceCenter);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(CreateServiceCenter), new { id = serviceCenter.Id }, serviceCenter);
        }

        // Add to ServiceCentersController.cs
[HttpGet("nearby")]
public async Task<ActionResult<IEnumerable<ServiceCenter>>> GetNearbyServiceCenters(double lat, double lng)
{
    var serviceCenters = await _context.ServiceCenters.ToListAsync();
    var nearbyCenters = serviceCenters
        .Where(sc => CalculateDistance(lat, lng, sc.Latitude, sc.Longitude) <= 1) // 1km radius
        .ToList();
    return Ok(nearbyCenters);
}

private double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
{
    const double R = 6371; // Earth's radius in km
    var dLat = ToRadians(lat2 - lat1);
    var dLon = ToRadians(lon2 - lon1);
    var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
            Math.Cos(ToRadians(lat1)) * Math.Cos(ToRadians(lat2)) *
            Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
    var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
    return R * c; // Distance in km
}

private double ToRadians(double deg) => deg * Math.PI / 180;
    }
}