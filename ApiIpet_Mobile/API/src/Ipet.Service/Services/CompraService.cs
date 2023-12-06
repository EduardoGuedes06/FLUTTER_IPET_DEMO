using Ipet.Data.Repository;
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;
using Ipet.Interfaces.Services;

namespace Ipet.Service.Services
{
    public class CompraService : BaseService, ICompraService
    {
        private readonly ICompraRepository _compraRepository;
        private readonly ICarrinhoRepository _carrinhoRepository;

        public CompraService(ICompraRepository compraRepository,
                               ICarrinhoRepository carrinhoRepository
                                , INotificador notificador)
            : base(notificador)
        {
            _compraRepository = compraRepository;
            _carrinhoRepository = carrinhoRepository;
        }

        public async Task FinalizarCompra(Guid usuarioId)
        {
            var carrinhoItens = await _carrinhoRepository.ObterPorUsuarioId(usuarioId);

            float total = 0;
            int quantidade = 0;

            if (!carrinhoItens.Any())
            {
                Notificar("Carrinho não encontrado ou vazio.");
                return;
            }

            foreach (var carrinhoItem in carrinhoItens)
            {
                total = total + carrinhoItem.Valor;
                quantidade = quantidade + carrinhoItem.Qtde;

                await _carrinhoRepository.Remover(carrinhoItem.Id);
            }

            Compra compra = new Compra();
            compra.UsuarioId = usuarioId;
            compra.Valor = total;
            compra.qtde = quantidade;
            await _compraRepository.Adicionar(compra);




        }

        public async Task<IEnumerable<Carrinho>> ObterCarrinhoPorUsuario(Guid usuarioId)
        {
            var carrinho = await _carrinhoRepository.ObterPorUsuarioId(usuarioId);
            return carrinho;
        }


        public async Task Dispose()
        {
            _carrinhoRepository?.Dispose();
        }

        public async Task<IEnumerable<Compra>> ObterCompraPorUsuario(Guid usuarioId)
        {
            var compra = await _compraRepository.ObterPorUsuarioId(usuarioId);
            return compra;
        }

    }
}
