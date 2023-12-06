using Ipet.Domain.Models;

namespace Ipet.Interfaces.Services
{
    public interface ICompraService
    {
        Task FinalizarCompra(Guid usuarioId);
        Task<IEnumerable<Carrinho>> ObterCarrinhoPorUsuario(Guid usuarioId);
        Task<IEnumerable<Compra>> ObterCompraPorUsuario(Guid usuarioId);
    }
}