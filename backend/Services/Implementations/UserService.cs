using Microsoft.AspNetCore.Identity;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Services.Contracts;
using Netmu.Utils.Security;

namespace Netmu.Services.Implementations;

public class UserService(
    UserManager<ApplicationUser> userManager,
    RoleManager<IdentityRole<Guid>> roleManager,
    IConfiguration configuration) : IUserService
{
    public async Task RegisterAsync(RegisterDto dto)
    {
        var existingUser = await userManager.FindByNameAsync(dto.Username);
        if (existingUser != null)
            throw new BadRequestException("Username already exists");

        var existingEmail = await userManager.FindByEmailAsync(dto.Email);
        if (existingEmail != null)
            throw new BadRequestException("Email already exists");

        var user = new ApplicationUser
        {
            UserName = dto.Username,
            Email = dto.Email,
        };

        var result = await userManager.CreateAsync(user, dto.Password);
        if (!result.Succeeded)
        {
            var errors = string.Join(", ", result.Errors.Select(e => e.Description));
            throw new BadRequestException(errors);
        }

        if (!await roleManager.RoleExistsAsync("user"))
            await roleManager.CreateAsync(new IdentityRole<Guid>("user"));

        await userManager.AddToRoleAsync(user, "user");
    }

    public async Task<LoginDtoResponse> LoginAsync(LoginDtoRequest dto)
    {
        var user = await userManager.FindByNameAsync(dto.Username);
        if (user == null || !await userManager.CheckPasswordAsync(user, dto.Password))
            throw new UnauthorizeException("Invalid username or password");

        var roles = await userManager.GetRolesAsync(user);
        var jwtSection = configuration.GetSection("Jwt");

        var token = Token.GenerateJwtToken(new JwtParams
        {
            Identifier = user.Id.ToString(),
            Name = user.UserName!,
            Roles = roles,
            Issuer = jwtSection["Issuer"] ?? "Netmu",
            Audience = jwtSection["Audience"] ?? "Netmu-Mobile",
            ExpiresInMinutes = int.Parse(jwtSection["ExpiresInMinutes"] ?? "60"),
        }, jwtSection["Secret"]!);

        return new LoginDtoResponse
        {
            AccessToken = token,
            RefreshToken = "",
        };
    }
}