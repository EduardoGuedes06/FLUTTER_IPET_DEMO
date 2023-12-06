using Ipet.Data.Context;
using Ipet.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace Ipet.Data.Repository
{
    public class CompraRepository : Repository<Compra>, ICompraRepository
    {
        public CompraRepository(MeuDbContext context) : base(context) { }


        public async Task<IEnumerable<Compra>> ObterPorUsuarioId(Guid usuarioId)
        {
            return await Db.Compras
                .Where(c => c.UsuarioId == usuarioId)
                .ToListAsync();
        }





    }
}