using AutoMapper;
using Ipet.Api.ViewModels;
using Ipet.API.Extensions;
using Ipet.API.Models;
using Ipet.API.ViewModels;
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;
using Ipet.Interfaces.Services;
using Ipet.Service.Services;
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
    [Route("compra")]
    public class CompraController : HomeController
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICarrinhoService _carrinhoService;
        private readonly ICompraService _compraService;
        private readonly IMapper _mapper;

        private readonly AppSettings _appSettings;
        private readonly ILogger _logger;
        public CompraController(ICarrinhoService carrinhoService,
                              IMapper mapper,INotificador notificador,
                              ICompraService compraService,
                              SignInManager<IdentityUser> signInManager,
                              UserManager<IdentityUser> userManager,
                              IOptions<AppSettings> appSettings,
                              IUser user, ILogger<AutenticacaoController> logger) : base(notificador, user)
        {
            _compraService = compraService;
            _carrinhoService = carrinhoService;
            _signInManager = signInManager;
            _userManager = userManager;
            _logger = logger;
            _appSettings = appSettings.Value;
            _mapper = mapper;
        }







        [HttpPost("finalizarCompra/{UsuarioId}")]
        public async Task<IActionResult> FinalizarCompra(Guid UsuarioId)
        {
            await _compraService.FinalizarCompra(UsuarioId);
            return Ok();
        }


        [HttpGet("obter-compras/{UsuarioId}")]
        public async Task<IActionResult> ObterCarrinhoPorUsuario(Guid UsuarioId)
        {
            var compras = await _compraService.ObterCompraPorUsuario(UsuarioId);

            if (compras == null || !compras.Any())
            {
                return NotFound("Nenhuma compra encontrada para o usuário.");
            }
            return Ok(compras);
        }









    }
}

