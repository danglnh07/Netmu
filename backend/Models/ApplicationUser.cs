using Microsoft.AspNetCore.Identity;

namespace Netmu.Models;

public class ApplicationUser : IdentityUser<Guid>
{
    public IEnumerable<Notification> Notifications { get; set; } = [];
}