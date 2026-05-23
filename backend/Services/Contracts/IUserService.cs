using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IUserService
{
    Task RegisterAsync(RegisterDto dto);
    Task<LoginDtoResponse> LoginAsync(LoginDtoRequest dto);
}