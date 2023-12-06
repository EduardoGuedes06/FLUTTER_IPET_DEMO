using AutoMapper;
using Ipet.Api.ViewModels;
using Ipet.Domain.Models;

namespace Ipet.API.Configuration
{
    public class AutoMapperConfig : Profile
    {
        public AutoMapperConfig()
        {
            CreateMap<Carrinho, CarrinhoViewModel>().ReverseMap();
            CreateMap<Compra, CompraViewModel>().ReverseMap();


        }
    }
}
