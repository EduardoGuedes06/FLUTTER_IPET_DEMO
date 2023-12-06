
using Ipet.Domain.Intefaces;
using Ipet.Domain.Models;

namespace Ipet.Data.Repository
{
    public interface ICompraRepository : IRepository<Compra>
    {
        Task<IEnumerable<Compra>> ObterPorUsuarioId(Guid usuarioId);
    }
}