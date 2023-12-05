using AutoMapper;
using Ipet.Api.ViewModels;
using Ipet.API.Extensions;
using Ipet.API.Models;
using Ipet.API.ViewModels;
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;
using Ipet.Interfaces.Services;
using LastCode.Identity.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using RouteAttribute = Microsoft.AspNetCore.Components.RouteAttribute;

namespace Ipet.API.Controllers
{
    //[Authorize]
    [ApiVersion("1.0")]
    [Route("aut")]
    public class MobileController : HomeController
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICarrinhoService _carrinhoService;
        private readonly IMapper _mapper;

        private readonly AppSettings _appSettings;
        private readonly ILogger _logger;
        public MobileController(ICarrinhoService carrinhoService,
            IMapper mapper,INotificador notificador,
                              SignInManager<IdentityUser> signInManager,
                              UserManager<IdentityUser> userManager,
                              IOptions<AppSettings> appSettings,
                              IUser user, ILogger<AutenticacaoController> logger) : base(notificador, user)
        {
            _carrinhoService = carrinhoService;
            _signInManager = signInManager;
            _userManager = userManager;
            _logger = logger;
            _appSettings = appSettings.Value;
            _mapper = mapper;
        }


        //[ClaimsAuthorize("Admin", "1")]
        [AllowAnonymous]
        [HttpPost("nova-conta-mobile")]
        public async Task<ActionResult> Registrar(RegisterUserViewModel Input)
        {
            if (!ModelState.IsValid) return CustomResponse(ModelState);

            var user = new ApplicationUser()
            {
                UserName = Input.Email,
                Nome = Input.Nome,
                Email = Input.Email,
                Documento = Input.Doc,
                Cep = Input.Cep,
                Numero = Input.Numero,
                Password = Input.Password,
                ConfirmPassord = Input.ConfirmPassword,
                Imagem = ""

            };

            var result = await _userManager.CreateAsync(user, Input.Password);
            if (result.Succeeded)
            {
                await _signInManager.SignInAsync(user, false);

                var claim = new Claim("Usuario", "1");
                await _userManager.AddClaimAsync(user, claim);

                return CustomResponse(await GerarJwt(user.Email));
            }
            foreach (var error in result.Errors)
            {
                NotificarErro(error.Description);
            }

            return CustomResponse(Input);
        }

        [AllowAnonymous]
        [HttpPost("entrar-mobile")]
        public async Task<ActionResult> Login(LoginUserViewModel loginUser)
        {
            if (!ModelState.IsValid) return CustomResponse(ModelState);

            var result = await _signInManager.PasswordSignInAsync(loginUser.Email, loginUser.Password, false, true);

            if (result.Succeeded)
            {
                _logger.LogInformation("Usuario " + loginUser.Email + " logado com sucesso");
                return CustomResponse(await GerarJwt(loginUser.Email));
            }
            if (result.IsLockedOut)
            {
                NotificarErro("Usuário temporariamente bloqueado por tentativas inválidas");
                return CustomResponse(loginUser);
            }

            NotificarErro("Usuário ou Senha incorretos");
            return CustomResponse(loginUser);
        }

        [Authorize]
        [HttpPost("test-token")]
        public async Task<ActionResult<bool>> Test()
        {

            return true;
        }
        private async Task<LoginResponseViewModel> GerarJwt(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            var claims = await _userManager.GetClaimsAsync(user);
            var userRoles = await _userManager.GetRolesAsync(user);

            claims.Add(new Claim(JwtRegisteredClaimNames.Sub, user.Id));
            claims.Add(new Claim(JwtRegisteredClaimNames.Email, user.Email));
            claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
            claims.Add(new Claim(JwtRegisteredClaimNames.Nbf, ToUnixEpochDate(DateTime.UtcNow).ToString()));
            claims.Add(new Claim(JwtRegisteredClaimNames.Iat, ToUnixEpochDate(DateTime.UtcNow).ToString(), ClaimValueTypes.Integer64));
            foreach (var userRole in userRoles)
            {
                claims.Add(new Claim("role", userRole));
            }

            var identityClaims = new ClaimsIdentity();
            identityClaims.AddClaims(claims);

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
            var token = tokenHandler.CreateToken(new SecurityTokenDescriptor
            {
                Issuer = _appSettings.Emissor,
                Audience = _appSettings.ValidoEm,
                Subject = identityClaims,
                Expires = DateTime.UtcNow.AddHours(_appSettings.ExpiracaoHoras),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            });

            var encodedToken = tokenHandler.WriteToken(token);

            var response = new LoginResponseViewModel
            {
                AccessToken = encodedToken,
                ExpiresIn = TimeSpan.FromHours(_appSettings.ExpiracaoHoras).TotalSeconds,
                UserToken = new UserTokenViewModel
                {
                    Id = user.Id,
                    Email = user.Email,
                    Claims = claims.Select(c => new ClaimViewModel { Type = c.Type, Value = c.Value })
                }
            };

            return response;
        }
        private static long ToUnixEpochDate(DateTime date) => (long)Math.Round((date.ToUniversalTime() - new DateTimeOffset(1970, 1, 1, 0, 0, 0, TimeSpan.Zero)).TotalSeconds);








        [HttpPost("adicionar-produto")]
        public async Task<IActionResult> CriarCarrinho(CarrinhoViewModel carrinhoViewModel)
        {

            var carrinho = _mapper.Map<Carrinho>(carrinhoViewModel);

            await _carrinhoService.CriarCarrinho(carrinho);
            return Ok();
        }

        [HttpPut("atualizar-quantidade/{CarrinhoId}")]
        public async Task<IActionResult> AtualizarQuantidadeProduto(Guid CarrinhoId, [FromBody] int novaQuantidade)
        {
            await _carrinhoService.AtualizarQuantidadeProduto(CarrinhoId, novaQuantidade);
            return Ok();
        }

        [HttpDelete("remover-produto/{CarrinhoId}")]
        public async Task<IActionResult> RemoverCarrinho(Guid CarrinhoId)
        {
            await _carrinhoService.RemoverCarrinho(CarrinhoId);
            return Ok();
        }

        [HttpGet("obter-carrinho/{UsuarioId}")]
        public async Task<IActionResult> ObterCarrinhoPorUsuario(Guid UsuarioId)
        {
            var carrinho = await _carrinhoService.ObterCarrinhoPorUsuario(UsuarioId);

            if (carrinho == null || !carrinho.Any())
            {
                return NotFound("Nenhum carrinho encontrado para o usuário.");
            }
            return Ok(carrinho);
        }

        [HttpPost("finalizarCompra/{UsuarioId}")]
        public async Task<IActionResult> FinalizarCompra(Guid UsuarioId)
        {
            await _carrinhoService.FinalizarCompra(UsuarioId);
            return Ok();
        }

    }
}

