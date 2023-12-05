namespace Ipet.Domain.Models
{
    public class Carrinho : Entity
    {
        public Guid UsuarioId { get; set; }
        public string NomeProduto { get; set; }
        public int Qtde { get; set; }
        public float Valor { get; set; }
    }
}
