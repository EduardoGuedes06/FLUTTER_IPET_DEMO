
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;

namespace Ipet.Data.Repository
{
    public interface ICarrinhoRepository : IRepository<Carrinho>
    {
        Task<IEnumerable<Carrinho>> ObterPorUsuarioId(Guid usuarioId);
    }
}