namespace Ipet.Domain.Models
{
    public class Compra : Entity
    {
        public Guid UsuarioId { get; set; }
        public int qtde { get; set; }
        public float Valor { get; set; }
    }
}
