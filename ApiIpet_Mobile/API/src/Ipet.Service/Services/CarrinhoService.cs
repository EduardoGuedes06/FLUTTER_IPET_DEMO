using Ipet.Data.Repository;
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;
using Ipet.Interfaces.Services;

namespace Ipet.Service.Services
{
    public class CarrinhoService : BaseService, ICarrinhoService
    {
        private readonly ICarrinhoRepository _carrinhoRepository;

        public CarrinhoService(ICarrinhoRepository carrinhoRepository, INotificador notificador)
            : base(notificador)
        {
            _carrinhoRepository = carrinhoRepository;
        }

        public async Task FinalizarCompra(Guid usuarioId)
        {
            var carrinhoItens = await _carrinhoRepository.ObterPorUsuarioId(usuarioId);

            if (!carrinhoItens.Any())
            {
                Notificar("Carrinho não encontrado ou vazio.");
                return;
            }

            foreach (var carrinhoItem in carrinhoItens)
            {
                await _carrinhoRepository.Remover(carrinhoItem.Id);
            }
        }

        public async Task<IEnumerable<Carrinho>> ObterCarrinhoPorUsuario(Guid usuarioId)
        {
            var carrinho = await _carrinhoRepository.ObterPorUsuarioId(usuarioId);
            return carrinho;
        }

        public async Task CriarCarrinho(Carrinho carrinho)
        {
            await _carrinhoRepository.Adicionar(carrinho);
        }

        public async Task AtualizarQuantidadeProduto(Guid CarrinhoId, int novaQuantidade)
        {
            var carrinho = await _carrinhoRepository.ObterPorId(CarrinhoId);

            if (carrinho == null)
            {
                Notificar("Carrinho não encontrado.");
                return;
            }


            carrinho.Qtde = novaQuantidade;

            await _carrinhoRepository.Atualizar(carrinho);
        }

        public async Task RemoverCarrinho(Guid carrinhoId)
        {
            await _carrinhoRepository.Remover(carrinhoId);
        }

        public async Task Dispose()
        {
            _carrinhoRepository?.Dispose();
        }
    }
}
