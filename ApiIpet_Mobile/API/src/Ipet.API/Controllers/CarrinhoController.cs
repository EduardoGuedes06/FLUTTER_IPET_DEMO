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
    [Route("carrinho")]
    public class CarrinhoController : HomeController
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly ICarrinhoService _carrinhoService;
        private readonly IMapper _mapper;

        private readonly AppSettings _appSettings;
        private readonly ILogger _logger;
        public CarrinhoController(ICarrinhoService carrinhoService,
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


        [HttpPost("adicionar-produto")]
        public async Task<IActionResult> CriarCarrinho(CarrinhoViewModel carrinhoViewModel)
        {

            var carrinho = _mapper.Map<Carrinho>(carrinhoViewModel);

            await _carrinhoService.CriarCarrinho(carrinho);
            return Ok();
        }

        [HttpPut("atualizar-quantidade/{CarrinhoId}/{novaQuantidade}")]
        public async Task<IActionResult> AtualizarQuantidadeProduto(Guid CarrinhoId, int novaQuantidade)
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


    }
}

