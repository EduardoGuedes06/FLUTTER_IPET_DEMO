using Ipet.Domain.Models;

namespace Ipet.Interfaces.Services
{
    public interface ICarrinhoService
    {
        Task AtualizarQuantidadeProduto(Guid CarrinhoId, int novaQuantidade);
        Task CriarCarrinho(Carrinho carrinho);
        Task FinalizarCompra(Guid usuarioId);
        Task<IEnumerable<Carrinho>> ObterCarrinhoPorUsuario(Guid usuarioId);
        Task RemoverCarrinho(Guid carrinhoId);
    }
}