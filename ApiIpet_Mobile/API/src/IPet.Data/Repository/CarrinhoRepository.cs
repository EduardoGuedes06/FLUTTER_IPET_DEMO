using Ipet.Data.Context;
using Ipet.Domain.Models;
using Microsoft.EntityFrameworkCore;

namespace Ipet.Data.Repository
{
    public class CarrinhoRepository : Repository<Carrinho>, ICarrinhoRepository
    {
        public CarrinhoRepository(MeuDbContext context) : base(context) { }


        public async Task<IEnumerable<Carrinho>> ObterPorUsuarioId(Guid usuarioId)
        {
            return await Db.Carrinhos
                .Where(c => c.UsuarioId == usuarioId)
                .ToListAsync();
        }





    }
}