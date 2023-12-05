using System.ComponentModel.DataAnnotations;

namespace Ipet.Api.ViewModels
{
    public class CarrinhoViewModel
    {
        [Key]
        public Guid Id { get; set; }

        [Required(ErrorMessage = "O campo UsuarioId é obrigatório.")]

        [Display(Name = "Produtos no Carrinho")]

        public Guid UsuarioId { get; set; }

        [Required(ErrorMessage = "O campo Nome é obrigatorio")]
        public string NomeProduto { get; set; }

        [Required(ErrorMessage = "O campo Quantidade é obrigatório.")]
        public int Qtde { get; set; }

        [Required(ErrorMessage = "O campo Valor é obrigatório.")]
        public float Valor { get; set; }

    }
}
